local f, err = loadfile('D:/Games/World of Warcraft/_classic_beta_/Interface/AddOns/RunReady/UI/MainFrame.lua')
if not f then
    print('ERROR:', err)
    os.exit(1)
else
    print('OK')
end
