local addonName, RR = ...

RR.PartyComms = {}

-- Share all active dungeon quests currently in player's log
function RR:ShareCurrentDungeonQuests(dungeonKey)
    dungeonKey = dungeonKey or (RR.charDB and RR.charDB.selectedDungeon) or "SFK"
    local audit = RR.QuestScanner:AuditDungeon(dungeonKey)
    if not audit then
        print(RR.title .. ": No dungeon selected or audit failed.")
        return
    end

    if not IsInGroup() then
        print(RR.title .. ": You are not currently in a party or raid group.")
        return
    end

    local pushedCount = 0
    for _, q in ipairs(audit.shareableInLog) do
        local inLog, _, isPushable, logIdx = RR.QuestScanner:GetQuestLogStatus(q.questID)
        if inLog and isPushable then
            if C_QuestLog and C_QuestLog.PushQuestToParty then
                C_QuestLog.PushQuestToParty(q.questID)
                pushedCount = pushedCount + 1
            elseif QuestLogPushQuest and logIdx then
                SelectQuestLogEntry(logIdx)
                QuestLogPushQuest()
                pushedCount = pushedCount + 1
            end
        end
    end

    if pushedCount > 0 then
        print(RR.title .. string.format(": Pushed %d shareable %s quest(s) to party.", pushedCount, audit.dungeon.name))
    else
        print(RR.title .. ": No shareable quests in your log for " .. audit.dungeon.name .. ".")
    end
end

-- Announce missing and non-shareable pickups to party chat
function RR:AnnounceToParty(dungeonKey)
    dungeonKey = dungeonKey or (RR.charDB and RR.charDB.selectedDungeon) or "SFK"
    local audit = RR.QuestScanner:AuditDungeon(dungeonKey)
    if not audit then return end

    local chatType = "PARTY"
    if IsInRaid() then
        chatType = "RAID"
    elseif not IsInGroup() then
        chatType = "EMOTE" -- print locally if solo
    end

    local header = string.format("[RunReady] %s Quest Status: %d/%d Ready", audit.dungeon.name, (audit.activeCount + audit.readyTurninCount), audit.totalCount)

    if chatType == "EMOTE" then
        print(RR.title .. " " .. header)
    else
        SendChatMessage(header, chatType)
    end

    if #audit.missingExternalPickups > 0 then
        local missingMsg = "[RunReady] Missing non-shareable pickups: "
        for i, q in ipairs(audit.missingExternalPickups) do
            local locStr = q.pickupLocation or "Outside"
            if q.pickupCoords then
                locStr = locStr .. string.format(" (%.1f, %.1f)", q.pickupCoords[1], q.pickupCoords[2])
            end
            missingMsg = missingMsg .. string.format("'%s' from %s in %s. ", q.title, q.pickupNPC or "Questgiver", locStr)
        end
        if chatType == "EMOTE" then
            print(RR.title .. " " .. missingMsg)
        else
            SendChatMessage(missingMsg, chatType)
        end
    else
        local allSet = "[RunReady] All available external quests are acquired or completed!"
        if chatType == "EMOTE" then
            print(RR.title .. " " .. allSet)
        else
            SendChatMessage(allSet, chatType)
        end
    end
end
