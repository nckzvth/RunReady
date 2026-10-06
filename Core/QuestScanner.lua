local addonName, RR = ...

RR.QuestScanner = {}
RR.completedCache = {}

-- Refresh completed quest cache
function RR.QuestScanner:RefreshCompletedQuests()
    if GetQuestsCompleted then
        local t = GetQuestsCompleted()
        if t and type(t) == "table" then
            for qid, v in pairs(t) do
                if v then RR.completedCache[qid] = true end
            end
        end
    end
    if C_QuestLog and C_QuestLog.GetAllCompletedQuestIDs then
        local list = C_QuestLog.GetAllCompletedQuestIDs()
        if list and type(list) == "table" then
            for _, qid in ipairs(list) do
                RR.completedCache[qid] = true
            end
        end
    end
end

function RR.QuestScanner:IsQuestCompleted(questID)
    if not questID then return false end
    if RR.completedCache[questID] then return true end

    if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted then
        if C_QuestLog.IsQuestFlaggedCompleted(questID) then
            RR.completedCache[questID] = true
            return true
        end
    end
    return false
end

-- Check active log status
function RR.QuestScanner:GetQuestLogStatus(questID)
    if not questID then return false, false, false end

    if C_QuestLog and C_QuestLog.GetNumQuestLogEntries then
        local numEntries = C_QuestLog.GetNumQuestLogEntries() or 0
        for i = 1, numEntries do
            local info = C_QuestLog.GetInfo(i)
            if info and not info.isHeader and info.questID == questID then
                local isComplete = false
                if C_QuestLog.IsComplete and C_QuestLog.IsComplete(questID) then
                    isComplete = true
                elseif C_QuestLog.ReadyForTurnIn and C_QuestLog.ReadyForTurnIn(questID) then
                    isComplete = true
                end

                local isPushable = false
                if C_QuestLog.IsPushableQuest then
                    isPushable = C_QuestLog.IsPushableQuest(questID)
                end

                return true, isComplete, isPushable, i
            end
        end
    elseif _G.GetNumQuestLogEntries and _G.GetQuestLogTitle then
        local numEntries = _G.GetNumQuestLogEntries() or 0
        for i = 1, numEntries do
            local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, qID = _G.GetQuestLogTitle(i)
            if not isHeader and qID == questID then
                local pushable = GetQuestLogPushable and GetQuestLogPushable(i)
                return true, (isComplete == 1 or isComplete == true), (pushable == true or pushable == 1), i
            end
        end
    end

    return false, false, false, nil
end

-- Comprehensive Dungeon Audit
function RR.QuestScanner:AuditDungeon(dungeonKey)
    local dungeon = RR:GetDungeon(dungeonKey)
    if not dungeon then return nil end

    self:RefreshCompletedQuests()
    local playerLevel = UnitLevel("player")
    local playerFaction = RR.Utils:GetPlayerFaction()

    local results = {
        dungeon = dungeon,
        quests = {},
        totalCount = 0,
        completedCount = 0,
        activeCount = 0,
        readyTurninCount = 0,
        availableCount = 0,
        lockedCount = 0,
        shareableInLog = {},
        missingExternalPickups = {},
    }

    for _, q in ipairs(dungeon.quests or {}) do
        -- Check faction filter
        if q.faction == "Both" or q.faction == playerFaction then
            -- Check class filter (if any)
            local classMatch = true
            if q.classes then
                local _, playerClass = UnitClass("player")
                classMatch = false
                for _, c in ipairs(q.classes) do
                    if c:lower() == (playerClass or ""):lower() then
                        classMatch = true
                        break
                    end
                end
            end

            if classMatch then
                results.totalCount = results.totalCount + 1

                local questEntry = {
                    data = q,
                    status = "AVAILABLE",
                    statusNote = "",
                    logIndex = nil,
                    isPushable = false,
                }

                local isDone = self:IsQuestCompleted(q.questID)
                local inLog, isReady, isPushable, logIdx = self:GetQuestLogStatus(q.questID)

                if isDone then
                    questEntry.status = "COMPLETED"
                    results.completedCount = results.completedCount + 1
                elseif inLog then
                    questEntry.logIndex = logIdx
                    questEntry.isPushable = isPushable
                    if isReady then
                        questEntry.status = "READY_TURNIN"
                        results.readyTurninCount = results.readyTurninCount + 1
                    else
                        questEntry.status = "ACTIVE"
                        results.activeCount = results.activeCount + 1
                    end

                    if isPushable then
                        table.insert(results.shareableInLog, q)
                    end
                else
                    -- Check Level
                    if q.minLevel and playerLevel < q.minLevel then
                        questEntry.status = "LEVEL_LOW"
                        questEntry.statusNote = string.format("Requires Level %d", q.minLevel)
                        results.lockedCount = results.lockedCount + 1
                    else
                        -- Check Prerequisites
                        local prereqsMet = true
                        local missingPrereqTitle = nil
                        if q.prereqs and #q.prereqs > 0 then
                            for _, pID in ipairs(q.prereqs) do
                                if not self:IsQuestCompleted(pID) then
                                    prereqsMet = false
                                    missingPrereqTitle = q.prereqTitle or ("Quest #" .. pID)
                                    break
                                end
                            end
                        end

                        if not prereqsMet then
                            questEntry.status = "LOCKED"
                            questEntry.statusNote = string.format("Pre-req needed: %s", missingPrereqTitle or "Prior Quest")
                            results.lockedCount = results.lockedCount + 1
                        else
                            questEntry.status = "AVAILABLE"
                            results.availableCount = results.availableCount + 1

                            -- If it is an external pickup (not inside instance), add to missing pickups list
                            if not q.inDungeon then
                                table.insert(results.missingExternalPickups, q)
                            end
                        end
                    end
                end

                table.insert(results.quests, questEntry)
            end
        end
    end

    -- Audit Natural Chains (if defined on dungeon)
    results.chains = {}
    if dungeon.chains then
        for _, ch in ipairs(dungeon.chains) do
            if ch.faction == "Both" or ch.faction == playerFaction then
                
                -- Check class filter across all steps in the chain
                local chainClassMatch = true
                local _, playerClass = UnitClass("player")
                for _, s in ipairs(ch.steps) do
                    if s.classes then
                        local stepMatch = false
                        for _, c in ipairs(s.classes) do
                            if c:lower() == (playerClass or ""):lower() then
                                stepMatch = true
                                break
                            end
                        end
                        if not stepMatch then
                            chainClassMatch = false
                            break
                        end
                    end
                end
                
                if chainClassMatch then
                    local auditedChain = {
                        name = ch.name,
                        faction = ch.faction,
                        badge = ch.badge,
                        steps = {},
                    totalSteps = #ch.steps,
                    completedSteps = 0,
                    isComplete = true,
                }

                local prevStepDone = true
                for sIdx, step in ipairs(ch.steps) do
                    local isDone = false
                    local inLog = false
                    local isReady = false
                    local isPushable = false
                    local logIdx = nil

                    if step.questID then
                        isDone = self:IsQuestCompleted(step.questID)
                        inLog, isReady, isPushable, logIdx = self:GetQuestLogStatus(step.questID)
                    end

                    local status = "AVAILABLE"
                    local statusNote = ""

                    if isDone then
                        status = "COMPLETED"
                        auditedChain.completedSteps = auditedChain.completedSteps + 1
                    else
                        auditedChain.isComplete = false
                        if inLog then
                            if isReady then
                                status = "READY_TURNIN"
                            else
                                status = "ACTIVE"
                            end
                        elseif not prevStepDone then
                            status = "LOCKED"
                            statusNote = "Prereq: Step " .. (sIdx - 1)
                        elseif step.minLevel and playerLevel < step.minLevel then
                            status = "LEVEL_LOW"
                            statusNote = string.format("Req Lvl %d", step.minLevel)
                        else
                            status = "AVAILABLE"
                        end
                    end

                    table.insert(auditedChain.steps, {
                        data = step,
                        status = status,
                        statusNote = statusNote,
                        isPushable = isPushable,
                        logIndex = logIdx,
                        stepNumber = sIdx,
                        totalSteps = #ch.steps,
                    })

                    prevStepDone = isDone
                end

                table.insert(results.chains, auditedChain)
                end
            end
        end
    else
        -- Synthesize natural chains from quests based on their actual pre/post structure
        for _, qEntry in ipairs(results.quests) do
            local q = qEntry.data
            local steps = {}

            -- Step 1..N: Pre-Quests (if any)
            if q.preQuests and #q.preQuests > 0 then
                for pIdx, p in ipairs(q.preQuests) do
                    table.insert(steps, {
                        step = #steps + 1,
                        phase = "PRE-DUNGEON",
                        questID = p.questID,
                        title = p.title,
                        pickupNPC = p.npc or "Questgiver",
                        pickupLocation = p.location or "World",
                        pickupCoords = p.coords,
                        minLevel = q.minLevel,
                        action = p.note or "Complete prerequisite task",
                        rewards = nil,
                    })
                end
            end

            -- Main In-Dungeon Step
            table.insert(steps, {
                step = #steps + 1,
                phase = (q.inDungeon == false and "PRE-DUNGEON" or "IN-DUNGEON"),
                questID = q.questID,
                title = q.title,
                pickupNPC = q.pickupNPC or "Questgiver",
                pickupLocation = q.pickupLocation or "Outside",
                pickupCoords = q.pickupCoords,
                minLevel = q.minLevel,
                action = q.note or "In-dungeon objective",
                turninNPC = (not q.postQuests or #q.postQuests == 0) and q.pickupNPC or nil,
                turninLocation = (not q.postQuests or #q.postQuests == 0) and q.pickupLocation or nil,
                rewards = (not q.postQuests or #q.postQuests == 0) and q.rewards or nil,
            })

            -- Post-Quests (if any)
            if q.postQuests and #q.postQuests > 0 then
                for pIdx, post in ipairs(q.postQuests) do
                    table.insert(steps, {
                        step = #steps + 1,
                        phase = "POST-DUNGEON",
                        questID = post.questID,
                        title = post.title or (q.title .. " (Turn-in)"),
                        pickupNPC = q.pickupNPC,
                        pickupLocation = q.pickupLocation,
                        turninNPC = post.turninNPC or q.pickupNPC or "Questgiver",
                        turninLocation = post.turninLocation or q.pickupLocation or "World",
                        turninCoords = post.turninCoords,
                        minLevel = q.minLevel,
                        action = post.note or "Claim dungeon rewards",
                        rewards = q.rewards,
                    })
                end
            end

            local auditedChain = {
                name = q.title,
                faction = q.faction,
                steps = {},
                totalSteps = #steps,
                completedSteps = 0,
                isComplete = (qEntry.status == "COMPLETED"),
            }

            for sIdx, s in ipairs(steps) do
                local status = qEntry.status
                if s.phase == "PRE-DUNGEON" and qEntry.status ~= "COMPLETED" then
                    status = "AVAILABLE"
                end
                table.insert(auditedChain.steps, {
                    data = s,
                    status = status,
                    statusNote = qEntry.statusNote,
                    isPushable = qEntry.isPushable,
                    logIndex = qEntry.logIndex,
                    stepNumber = sIdx,
                    totalSteps = #steps,
                })
            end

            table.insert(results.chains, auditedChain)
        end
    end

    return results
end
