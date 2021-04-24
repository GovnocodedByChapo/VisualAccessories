script_name('VisualAccessories for Arizona RolePlay')
script_author('Chapo (vk.com/amid24)')

require("moonloader")
local imgui = require('imgui')
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local sampev = require 'lib.samp.events'
local window = imgui.ImBool(false)
local memory = require "memory"

--UPDATE
local dlstatus = require('moonloader').download_status
update_state = false

local script_vers = 1.3
local script_vers_text = "1.3"

local update_url = "https://raw.githubusercontent.com/GovnocodedByChapo/scripts/main/VisualAccessories.ini" -- тут тоже свою ссылку
local update_path = getWorkingDirectory() .. "/update.ini" -- и тут свою ссылку

local script_url = "https://github.com/thechampguess/scripts/blob/master/autoupdate_lesson_16.luac?raw=true" -- тут свою ссылку
local script_path = thisScript().path

--INI
local inicfg = require 'inicfg'

local directIni = 'VisualAccessories_by_Chapo.ini'
local ini = inicfg.load(inicfg.load({
    slots = {
        slot0 = 0,
        slot1 = 0,
        slot2 = 0,
        slot3 = 0,
        slot4 = 0,
        slot5 = 0,
        glow = 0,
        case = 0,
    },
    other = {
        only_arz = false,
    },
    skin = {
        enabled = false,
        skinid = 49,
        skin_select_mode = 1,
        rollerFix = true,
        NormalSkinsTurn = true,
    },
}, directIni))
inicfg.save(ini, directIni)

--SKIN
local skin_enabled = imgui.ImBool(ini.skin.enabled)
local skinid = imgui.ImInt(ini.skin.skinid)
local skin_select_mode = imgui.ImInt(ini.skin.skin_select_mode)
local skin_rollerFix = imgui.ImBool(ini.skin.rollerFix)
local skin_NormalSkinsTurn = imgui.ImBool(ini.skin.NormalSkinsTurn)

--LOGGER
local logger = imgui.ImBool(false)
local log_text = imgui.ImBuffer(256)
local log_player = imgui.ImInt(0)
local acs_logger = imgui.ImBool(false)

--SLOTS
local slot0_items = {u8'Ничего', u8'Нимб', u8'Белый цилиндр', u8'Черный цилиндр', u8'Медецинская маска', u8'Бургер', u8'Боксерский шлем', u8'Вибратор #1', u8'Шляпа фермера', u8'Шляпа мага', u8'Каска строителя', u8'Бумбокс', u8'Скейт', u8'Крылья (2)', u8'Шлем (розовый)'}
local slot0_selected = imgui.ImInt(ini.slots.slot0)

local slot1_items = {u8'Ничего', u8'Попугай на плечо', u8'Маска демона', u8'Доска для серфа (1)', u8'ПНВ', u8'Колонка', u8'Крест', u8'Уши бетмена', u8'Шляпа полицейского', u8'Голова оленя', u8'Дельфин'}
local slot1_selected = imgui.ImInt(ini.slots.slot1)

local slot2_items = {u8'Ничего', u8'Рога', u8'Игрушка на Р/У', u8'Серый щит на руку'}
local slot2_selected = imgui.ImInt(ini.slots.slot2)

local slot3_items = {u8'Ничего', u8'Борода (белая)', u8'Респиратор', u8'Доллар на грудь', u8'Сердце на грудь', u8'Елка на плечо'}
local slot3_selected = imgui.ImInt(ini.slots.slot3)

local slot4_items = {u8'Ничего', u8'Курица на плечо', u8'Шар на плечо (1)', u8'Красная гитара', u8'Шар на плечо (2)', u8'Шар на плечо (3)', u8'Шар на плечо (4)', u8'Шар на плечо (5)', u8'Шар на плечо (6)', u8'Шар на плечо (7)', u8'Олень', u8'Биг Смоук', u8'Крылья', u8'Тыква на голову', u8'Бита на спину', u8'Подарок на спину'}
local slot4_selected = imgui.ImInt(ini.slots.slot4)

local slot5_items = {u8'Ничего', u8'Щит', u8'Катана', u8'Лопата', u8'Ларек (доллар)', u8'Ларек (нарко)', u8'Ларек (яблоки)', u8'Мешок с мясом', u8'Дракон', u8'Фонтан', u8'Миниган', u8'Огнемет'}
local slot5_selected = imgui.ImInt(ini.slots.slot5)

local case_items = {u8'Ничего', u8'Стандартный кейс', u8'Сумка для ноутбука', u8'Красный кейс'}
local case_selected = imgui.ImInt(ini.slots.case)

local glow = imgui.ImInt(ini.slots.glow)

--ALL ITEMS SETTINGS ( name = {modelId, bone, offsetX, offsetY, offsetZ, rotationX, rotationY, rotationZ, scaleX, scaleY, scaleZ} )
    --SLOT 0 ITEM LIST DATA 
    local nimb = {19197, 2, 0.20999899506569, 0, 0, 0, 84.499977111816, 0, 0.26599898934364, 0.27300000190735, 0}
    local cilinderWhite = {19487, 2, 0.08500000089407, 0.0059989998117089, -0.0039989999495447, 83.900001525879, 67.899978637695, 3.1999990940094, 1.078999042511, 0.96200001239777, 1}
    local cilinderBlack = {19352, 2, 0.10999900102615, -0.003000000026077, 0, -78.300010681152, 113.10001373291, -13.799969673157, 1.1149990558624, 1.097000002861, 1}
    local medMask = {11736, 2, -0.017000000923872, 0.064000003039837, -0.0019990000873804, 0, 0, 11.199993133545, 0.26100000739098, 0.44699901342392, 2.6970009803772}
    local burger = {19094, 2, 0.13699799776077, -0.00099900003988296, -0.0029990000184625, 0, 0, 0, 0.82999902963638, 0.82300001382828, 0.79399901628494}
    local boxHelmet = {18952, 2, 0.088999003171921, 0.018999999389052, -0.0020000000949949, 0, 0, -6.2999992370605, 1.2780009508133, 1.1880029439926, 1.2549999952316}
    local vibrator1 = {322, 1, -0.0089999996125698, -0.18399800360203,  0.082999996840954, 0, 69.499992370605, 0, 1.6199990510941, 1.6379990577698, 2.549998998642}
    local farm_hat = {19553, 2, 0.15399999916553, -0.018998999148607, 0.0060000000521541, -5.4999980926514, -7.7999949455261, -32.600002288818, 1.1309989690781, 1.4560010433197, 1.2710009813309}
    local wizard_hat = {19528, 2, 0.1089999973774, -0.0019990000873804, -0.0020000000949949, 0, 0, -29.199979782104, 1, 1.5060019493103, 1.0719989538193}
    local builder_hat = {18638, 2, 0.16400299966335, 0.016999000683427, -0.00099900003988296, 0, 0, -8.399974822998, 0.69499897956848, 0.9279950261116, 1.002995967865}
    local boombox = {2226, 1, 0.080999001860619, -0.2039940059185, -0.062999002635479, 0, 34.5, 0, 0.67599999904633, 0.783999979496, 0.7599989771843}
    local skate = {19878, 1, 0.10499999672174, -0.15600000321865, -0.010999999940395, -90.699935913086, -6.0000061988831, 158.2999420166, 0.68699997663498, 0.69799900054932, 1}
    local wings2 = {1177, 1, -0.10989999771118, -0.15500000119209, 0.4239000082016, -89.800003051758, -0.799899995327, 88.300003051758, 0.46889999508858, 1.8400000333786, 0.30790001153946}
    local helmet_purple = {18979, 2, 0.072999000549316, 0.013000000268221, 0, 88.600006103516, 91.099998474121, 0, 1.1290010213852, 0.97299897670746, 1.0499999523163}

    --SLOT 1 ITEM LIST DATA
    local parrot = {19079, 1, 0.29200100898743, -0.054999001324177, 0.12799899280071, 0, -20.699991226196, 0.12, 0.53399902582169, 0.64999997615814, 0.64700001478195}
    local demonMask = {11704, 2, 0.086000002920628, 0.1140009984374, -0.0060000000521541, 90.200019836426, 83.900115966797, 87, 0.28599798679352, 0.41400000452995, 0.37799799442291}
    local surf1 = {2406, 1, 0.050999000668526, -0.10700000077486, -0.040998999029398, 3, 56.20002746582, -6.899995803833, 0.56399899721146, 0.88999897241592, 0.46999898552895}
    local PNV = {368, 2, 0, 0.10099899768829, -0.0039989999495447, 0, 0, -1.0999970436096, 1, 1, 0.98099899291992}
    local kolonka = {2102, 1, 0.043999001383781, -0.15599900484085, -0.076999001204967, 0, 31.199995040894, 0, 0.75400000810623, 0.76299899816513, 0.7119989991188}
    local krest = {11712, 1, 0.2660000026226, 0.125, -0.0059989998117089, 87.900009155273, 60.300243377686, 0, 1.4189989566803, 0.56699997186661, 0.47299998998642}
    local batman = {1013, 2, 0.16490000486374, 0.0070000002160668, 0, 92.499900817871, 178.30000305176, -92.799896240234, 0.10490000247955, 0.78990000486374, 0.22800000011921}
    local police_hat = {19099, 2, 0.17599999904633, -0.0060000000521541, -0.0029990000184625, 0, 0, -11.100002288818, 1.0509999990463, 1.1280020475388, 1.1110010147095}
    local golova_olenya = {1736, 2, 0.057900000363588, -0.018899999558926, -0.0168999992311, 83.799896240234, 18.699899673462, 95.699996948242, 0.97289997339249, 0.87300002574921, 0.61690002679825}
    local dolphine = {1607, 1, 0.12189999967813, -0.23989999294281, 0.008899999782443, 87.599998474121, 21.89999961853, -91.199996948242, 0.25090000033379, 0.14990000426769, 0.20600000023842}

    --SLOT 2 ITEM LIST DATA
    local roga = {19314, 2, 0.086998999118805, 0.0010000000474975, -0.0019990000873804, 0, 0, -83.199989318848, 0.70799899101257, 0.60199999809265, 0.31999999284744}
    local ru_igr = {364, 6, 0.078998997807503, 0.018999999389052, 0.0089990003034472, 0, -93.299949645996, 5.0000028610229, 1, 1, 1}
    local gray_shield = {1366, 14, 0.046900000423193, 0.016000000759959, -0.039900001138449, 17.200000762939, 175.99969482422, 114.30000305176, 2.7000000476837, 1.3128999471664, 0.038899999111891}

    --SLOT 3 ITEM LIST DATA
    local beard = {19517, 2, -0.010999999940395, 0.064000003039837, 0, 0, 0, -162.10018920898, 0.33300000429153, 0.60399901866913, 0.57099902629852}
    local respirator = {19472, 2, -0.0070009999908507, 0.12899899482727, -0.00099900003988296, -2.9000000953674, 88.200019836426, 93.200096130371, 1.0439889431, 1.2140029668808, 1.0960010290146}
    local dollar = {1274, 1, 0.12700000405312, 0.13500000536442, -0.0019990000873804, -88.600067138672, 106.29999542236, -95.799903869629, 0.23600000143051, 1.5169999599457, 0.21400000154972}
    local serdce1 = {1240, 1, 0.12290000170469, 0.15289999544621, -0.0040000001899898, 87.299896240234, 78.199897766113, -89.599899291992, 0.6370000243187, 0.86890000104904, 0.61000001430511}
    local elka = {19076, 16, 0.17790000140667, -0.014899999834597, 0, 2.7999000549316, -176.89990234375, 0, 0.046000000089407, 0.050000000745058, 0.041000001132488}

    --SLOT 4 ITEM LIST DATA
    local chicken = {16776, 1, 0.30399999022484, -0.012999000027776, 0.14299899339676, 3.8000090122223, 79.100120544434, -179.59983825684, 0.0070000002160668, 0.0060000000521541, 0.0099980002269149}
    local shar1 = {19332, 1, 0.35399898886681, -0.017000000923872, 0.18599900603294, 0, 86.599998474121, 0, 0.0089999996125698, 0.0089990003034472, 0.0089990003034472}
    local guitarRed = {19317, 1, 0.17599999904633, -0.10800000280142, -0.052999000996351, 4.1999940872192, 119.29999542236, -4.7000007629395, 0.68800002336502, 1, 0.69599997997284}
    local shar2 = {19333, 1, 0.35399898886681, -0.017000000923872, 0.18599900603294, 0, 86.599998474121, 0, 0.0089999996125698, 0.0089990003034472, 0.0089990003034472}
    local shar3 = {19334, 1, 0.35399898886681, -0.017000000923872, 0.18599900603294, 0, 86.599998474121, 0, 0.0089999996125698, 0.0089990003034472, 0.0089990003034472}
    local shar4 = {19335, 1, 0.35399898886681, -0.017000000923872, 0.18599900603294, 0, 86.599998474121, 0, 0.0089999996125698, 0.0089990003034472, 0.0089990003034472}
    local shar5 = {19336, 1, 0.35399898886681, -0.017000000923872, 0.18599900603294, 0, 86.599998474121, 0, 0.0089999996125698, 0.0089990003034472, 0.0089990003034472}
    local shar6 = {19337, 1, 0.35399898886681, -0.017000000923872, 0.18599900603294, 0, 86.599998474121, 0, 0.0089999996125698, 0.0089990003034472, 0.0089990003034472}
    local shar7 = {19338, 1, 0.35399898886681, -0.017000000923872, 0.18599900603294, 0, 86.599998474121, 0, 0.0089999996125698, 0.0089990003034472, 0.0089990003034472}
    local olen = {19315, 1, 0.21189999580383, 0.10000000149012, -0.1630000025034, 87.699897766113, 80.999900817871, 1.8998999595642, 1, 1, 1}
    local bigsmoke = {14467, 1, 0.45590001344681, 0.018899999558926, 0.17689999938011, 0, 85.39990234375, -178, 0.090899996459484, 0.10400000214577, 0.082900002598763}
    local wings_old = {8492, 1, 0.054999001324177, -0.11100000143051, -0.0019990000873804, -91.699813842773, -96.099952697754, -109.60003662109, 0.057000000029802, 0.034000001847744, 0.090000003576279}
    local pupkin_head = {19320, 2, 0.15699900686741, -0.0040000001899898, 0, 0, 89.799995422363, 0, 0.65600001811981, 0.6339989900589, 0.7239990234375}
    local bita = {336, 1, -0.12599900364876, -0.14299799501896, -0.13099899888039, 0, 47.100002288818, 0, 1, 1, 1}
    local podarok = {19057, 1, 0.10999999940395, -0.18699899315834, 0, 0, 85.89998626709, 0, 0.23999999463558, 0.18099999427795, 0.39899900555611}

    --SLOT 5 ITEM LIST DATA
    local shield = {18637, 1, 0.077999003231525, -0.034999001771212, 0.12099999934435, 87.19994354248, -0.9, -73, 0.71499997377396, 0.78600001335144, 1.0479990243912}
    local katana = {339, 1, 0.30299898982048, -0.12000100314617, -0.21399900317192, 0.19999699294567, -53.899978637695, -5.4999890327454, 1, 1, 0.79699999094009}
    local lopata = {337, 1, -0.061999000608921, -0.179000005126, -0.082000002264977, -1.2000000476837, 59.700004577637, 97.69994354248, 1, 1, 1}
    local larek_dollar = {1212, 1, 0.12599900364876, -0.077999003231525, -0.0049999998882413, 90.499923706055, 0, -23.599962234497, 2.0409979820251, 2.689001083374, 1.4119999408722}
    local larek_narko = {1575, 1, 0.061997998505831, -0.030999999493361, 0.002998000010848, 89.900100708008, 0, 0, 0.73000001907349, 0.73999798297882, 0.95300000905991}
    local larek_apple = {19636, 1, -0.093998000025749, -0.20499999821186, 0.0049999998882413, -0.30000001192093, 89.300079345703, -1.299998998642, 0.46299800276756, 0.20299799740314, 2.5520000457764}
    local meatbag = {2805, 1, 0.12799899280071, -0.1799979954958, 0.0089990003034472, 0, 74.400016784668, 0, 0.59399998188019, 0.63599902391434, 0.42799898982048}
    local dragon = {3528, 1, 0.045899998396635, -0.20990000665188, 0, 127.5, 93.800003051758, 137.09989929199, 0.090000003576279, 0.10989999771118, 0.10989999771118}
    local fontan = {19840, 1, -0.40090000629425, -0.25490000844002, 0.025000000372529, 94.699897766113, 59.499900817871, -96.999900817871, 0.054900001734495, 0.072899997234344, 0.12389999628067}
    local minigun = {362, 1, 0.52799898386002, -0.18199899792671, -0.0049990001134574, 176.59999084473, -178.39958190918, 0, 0.65299999713898, 0.77699899673462, 0.82700002193451}
    local ognemet = {361, 1, 0.54399901628494, -0.15599900484085, -0.10300000011921, -177.3000793457, 176.40005493164, 0, 0.76800000667572, 0.7059999704361, 0.74899899959564}


function main()
    while not isSampAvailable() do wait(200) end
    while not sampIsLocalPlayerSpawned() do wait(200) end
    skin_saved = getCharModel(PLAYER_PED)
    sampRegisterChatCommand('acs', function()
        window.v = not window.v
    end)
    imgui.Process = false
    window.v = false  --show window
    apply()
   
    while true do
        wait(0)
        imgui.Process = window.v
        if ini.other.only_arz and not sampGetCurrentServerName():find('Arizona') then for i = 0, 7 do clear(i) end end

        --RollerFix by Chapo (https://www.blast.hk/threads/80279/)
        if skin_rollerFix.v then rollerFix() end 

        --NormalTurnFix by FYS (https://www.blast.hk/threads/41127/)
        if skin_NormalSkinsTurn.v then
            CPed = getCharPointer(PLAYER_PED)
            memory.write(CPed + 0x560, 1089470464, 4, 0)
        end

        downloadUrlToFile(update_url, update_path, function(id, status)
            if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                updateIni = inicfg.load(nil, update_path)
                if tonumber(updateIni.update.version) > script_vers then
                    sampAddChatMessage("Есть обновление! Версия: " .. updateIni.update.versionlast, -1)
                    update_state = true
                end
                os.remove(update_path)
            end
        end)
        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("Скрипт успешно обновлен!", -1)
                    thisScript():reload()
                end
            end)
            break
        end
    end
end

function imgui.OnDrawFrame()
    if window.v then
        window_size_x, window_size_y = 240, 350
        resX, resY = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2 - window_size_x / 2, resY / 2 - window_size_y / 2), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowSize(imgui.ImVec2(window_size_x, window_size_y), imgui.Cond.FirstUseEver)
        imgui.Begin('ViasualAccessories by Chapo (v1.31)', window, imgui.WindowFlags.NoResize)
        
        imgui.Text(u8'Слот #0: ')
        imgui.SameLine()
        if imgui.Combo('###slot0combo', slot0_selected, slot0_items, #slot0_items) then apply() end
        imgui.NewLine()

        imgui.Text(u8'Слот #1: ')
        imgui.SameLine()
        if imgui.Combo('###slot1combo', slot1_selected, slot1_items, #slot1_items) then apply() end
        imgui.NewLine()

        imgui.Text(u8'Слот #2: ')
        imgui.SameLine()
        if imgui.Combo('###slot2combo', slot2_selected, slot2_items, #slot2_items) then apply() end


        imgui.NewLine()

        imgui.Text(u8'Слот #3: ')
        imgui.SameLine()
        if imgui.Combo('###slot3combo', slot3_selected, slot3_items, #slot3_items) then apply() end


        imgui.NewLine()

        imgui.Text(u8'Слот #4: ')
        imgui.SameLine()
        if imgui.Combo('###slot4combo', slot4_selected, slot4_items, #slot4_items) then apply() end
        
        imgui.NewLine()

        imgui.Text(u8'Слот #5: ')
        imgui.SameLine()
        if imgui.Combo('###slot5combo', slot5_selected, slot5_items, #slot5_items) then apply() end



        imgui.NewLine()
        
        imgui.Text(u8'+50%:      ')
        imgui.SameLine()
        if imgui.Combo('###skinglow', glow, {u8'Выключено', u8'Включено'}, 2) then apply() end

        imgui.NewLine()

        imgui.Text(u8'Кейс:      ')
        imgui.SameLine()
        if imgui.Combo('###moneycase', case_selected, case_items, #case_items) then apply() end

        imgui.NewLine()

        --SKIN MENU
        imgui.SetCursorPosX(5)
        if imgui.Button(u8'Изменить скин', imgui.ImVec2(230, 20)) then imgui.OpenPopup(u8'Настройка скина') end
        imgui.SetNextWindowSize(imgui.ImVec2(window_size_x, 150), imgui.Cond.FirstUseEver)
        if imgui.BeginPopupModal(u8'Настройка скина', imgui.WindowFlags.NoResize) then
            imgui.Text(u8'Изменение скина: ')
            imgui.SameLine()
            if imgui.Checkbox('###', skin_enabled) then
                if not skin_enabled.v then set_player_skin(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)), skin_saved) else set_player_skin(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)), skinid.v) end
            end

            imgui.SameLine()
            imgui.Combo('skin_select_mode', skin_select_mode, {u8'Слайдер', u8'Поле ввода'}, 2)

            imgui.Text(u8'id скина')
            imgui.SameLine()
            imgui.SetCursorPosX(60)
            imgui.PushItemWidth(window_size_x - 65)
            if skin_select_mode.v == 0 then
                if imgui.SliderInt('###', skinid, 0, 311) then if skin_enabled.v then set_player_skin(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)), skinid.v) else skinid.v = ini.skin.skinid end end
            else
                if imgui.InputInt('###skinidinputsukaebaniyvrot', skinid) then if skin_enabled.v then set_player_skin(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)), skinid.v) else skinid.v = ini.skin.skinid end end
                imgui.PopItemWidth()
            end

            imgui.NewLine()
            imgui.Checkbox('RollerFix', skin_rollerFix)
            imgui.SameLine()
            imgui.TextQuestion(u8'Удаление разгона у 92 и 99 скинов (by Chapo)')
            
            imgui.Checkbox('NormalSkinsTurn', skin_NormalSkinsTurn)
            imgui.SameLine()
            imgui.TextQuestion(u8'Фикс резких поворотов у некоторых скинов. (by FYS)\nПосле отключения требуется перезаход в игру!')
            imgui.NewLine()
            if imgui.Button(u8'Закрыть', imgui.ImVec2(window_size_x - 10, 20)) then imgui.CloseCurrentPopup() end
            imgui.EndPopup()
        end

        
        imgui.NewLine()

        imgui.SetCursorPos(imgui.ImVec2(1, window_size_y - 25))
        imgui.CenterTextColoredRGB('{ffffff}Автор: {ff004d}Chapo')
        if imgui.IsItemClicked(0) then
            imgui.OpenPopup(u8'Автор: Chapo')
            --os.execute('explorer "https://vk.com/amid24"')
        end
        
        if imgui.BeginPopupModal(u8'Автор: Chapo', imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoResize) then
            imgui.SetWindowSize(imgui.ImVec2(170, 100))
            imgui.SetCursorPosX(5)
            if imgui.Button('VK', imgui.ImVec2(50, 50)) then os.execute('explorer "https://vk.com/amid24"') end
            imgui.SameLine()
            imgui.SetCursorPosX(60)
            if imgui.Button('BH', imgui.ImVec2(50, 50)) then os.execute('explorer "https://www.blast.hk/members/112329/"') end
            imgui.SameLine()
            imgui.SetCursorPosX(115)
            if imgui.Button(u8'Тема', imgui.ImVec2(50, 50)) then os.execute('explorer "https://www.blast.hk/threads/85370/"') end
            imgui.SetCursorPosX(5)
            if imgui.Button(u8'Закрыть', imgui.ImVec2(160, 20)) then imgui.CloseCurrentPopup() end
            imgui.EndPopup()
        end
        imgui.End()
    end
end

function apply()
    if skin_enabled.v and getCharModel(PLAYER_PED) ~= skinid.v then set_player_skin(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)), skinid.v) end

    if slot0_selected.v == 0 then
        clear(0)
    elseif slot0_selected.v == 1 then
        slotApply(0, nimb)
    elseif slot0_selected.v == 2 then
        slotApply(0, cilinderWhite)
    elseif slot0_selected.v == 3 then
        slotApply(0, cilinderBlack)
    elseif slot0_selected.v == 4 then
        slotApply(0, medMask)
    elseif slot0_selected.v == 5 then
        slotApply(0, burger)
    elseif slot0_selected.v == 6 then
        slotApply(0, boxHelmet)
    elseif slot0_selected.v == 7 then
        slotApply(0, vibrator1)
    elseif slot0_selected.v == 8 then
        slotApply(0, farm_hat)
    elseif slot0_selected.v == 9 then
        slotApply(0, wizard_hat)
    elseif slot0_selected.v == 10 then
        slotApply(0, builder_hat)
    elseif slot0_selected.v == 11 then
        slotApply(0, boombox)
    elseif slot0_selected.v == 12 then
        slotApply(0, skate)
    elseif slot0_selected.v == 13 then
        slotApply(0, wings2)
    elseif slot0_selected.v == 14 then
        slotApply(0, helmet_purple)
    end

    if slot1_selected.v == 0 then
        clear(1)
    elseif slot1_selected.v == 1 then
        slotApply(1, parrot)
    elseif slot1_selected.v == 2 then
        slotApply(1, demonMask)
    elseif slot1_selected.v == 3 then
        slotApply(1, surf1)
    elseif slot1_selected.v == 4 then
        slotApply(1, PNV)
    elseif slot1_selected.v == 5 then
        slotApply(1, kolonka)
    elseif slot1_selected.v == 6 then
        slotApply(1, krest)
    elseif slot1_selected.v == 7 then
        slotApply(1, batman)
    elseif slot1_selected.v == 8 then
        slotApply(1, police_hat)
    elseif slot1_selected.v == 9 then
        slotApply(1, golova_olenya)
    elseif slot1_selected.v == 10 then
        slotApply(1, dolphine)
    end
   
    if slot2_selected.v == 0 then
        clear(2)
    elseif slot2_selected.v == 1 then
        slotApply(2, roga)
    elseif slot2_selected.v == 2 then
        slotApply(2, ru_igr)
    elseif slot2_selected.v == 3 then
        slotApply(2, gray_shield)
    end

    if slot3_selected.v == 0 then
        clear(3)
    elseif slot3_selected.v == 1 then
        slotApply(3, beard)
    elseif slot3_selected.v == 2 then
        slotApply(3, respirator)
    elseif slot3_selected.v == 3 then
        slotApply(3, dollar)
    elseif slot3_selected.v == 4 then
        slotApply(3, serdce1)
    elseif slot3_selected.v == 5 then
        slotApply(3, elka)
    end

    apply2() --разбил на 2 части так как вылезало "function at line 297 has more than 60 upvalues"
end

function apply2()
    if slot4_selected.v == 0 then
        clear(4)
    elseif slot4_selected.v == 1 then
        slotApply(4, chicken)
    elseif slot4_selected.v == 2 then
        slotApply(4, shar1)
    elseif slot4_selected.v == 3 then
        slotApply(4, guitarRed)
    elseif slot4_selected.v == 4 then
        slotApply(4, shar2)
    elseif slot4_selected.v == 5 then
        slotApply(4, shar3)
    elseif slot4_selected.v == 6 then
        slotApply(4, shar4)
    elseif slot4_selected.v == 7 then
        slotApply(4, shar5)
    elseif slot4_selected.v == 8 then
        slotApply(4, shar6)
    elseif slot4_selected.v == 9 then
        slotApply(4, shar7)
    elseif slot4_selected.v == 10 then
        slotApply(4, olen)
    elseif slot4_selected.v == 11 then
        slotApply(4, bigsmoke)
    elseif slot4_selected.v == 12 then
        slotApply(4, wings_old) 
    elseif slot4_selected.v == 13 then
        slotApply(4, pupkin_head)
    elseif slot4_selected.v == 14 then
        slotApply(4, bita)
    elseif slot4_selected.v == 15 then
        slotApply(4, podarok)
    end

    if slot5_selected.v == 0 then
        clear(5)
    elseif slot5_selected.v == 1 then
        slotApply(5, shield)
    elseif slot5_selected.v == 2 then
        slotApply(5, katana)
    elseif slot5_selected.v == 3 then
        slotApply(5, lopata)
    elseif slot5_selected.v == 4 then
        slotApply(5, larek_dollar)
    elseif slot5_selected.v == 5 then
        slotApply(5, larek_narko)
    elseif slot5_selected.v == 6 then
        slotApply(5, larek_apple)
    elseif slot5_selected.v == 7 then
        slotApply(5, meatbag)
    elseif slot5_selected.v == 8 then
        slotApply(5, dragon)
    elseif slot5_selected.v == 9 then
        slotApply(5, fontan)
    elseif slot5_selected.v == 10 then
        slotApply(5, minigun)
    elseif slot5_selected.v == 11 then
        slotApply(5, ognemet)
    end
    
    if glow.v == 0 then
        clear(6)
    elseif glow.v == 1 then
        glowEffect()
    end

    if case_selected.v == 0 then
        clear(7)
    elseif case_selected.v == 1 then
        case_default()
    elseif case_selected.v == 2 then
        case_laptop()
    elseif case_selected.v == 3 then
        case_red()
    end
end


function set_player_skin(id, skin)
	local BS = raknetNewBitStream()
	raknetBitStreamWriteInt32(BS, id)
	raknetBitStreamWriteInt32(BS, skin)
	raknetEmulRpcReceiveBitStream(153, BS)
	raknetDeleteBitStream(BS)
end

function clear(slot)
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt16(bs, select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) -- playerId
    raknetBitStreamWriteInt32(bs, slot) -- index
    raknetBitStreamWriteBool(bs, false) -- create
    raknetEmulRpcReceiveBitStream(113, bs)
    raknetDeleteBitStream(bs)
end

function sampev.onSetPlayerAttachedObject(playerId, index, create, object)
    --if playerId ==  select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) and object.modelId == 0 then return false end
    if playerId ==  select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) then
        if slot0_selected.v ~= 0 and index == 0 and object.modelId == 0 then return false end
        if slot1_selected.v ~= 0 and index == 1 and object.modelId == 1 then return false end
        if slot2_selected.v ~= 0 and index == 2 and object.modelId == 2 then return false end
        if slot3_selected.v ~= 0 and index == 3 and object.modelId == 3 then return false end
        if slot4_selected.v ~= 0 and index == 4 and object.modelId == 4 then return false end
        if slot5_selected.v ~= 0 and index == 5 and object.modelId == 5 then return false end
        if slot6_selected.v ~= 0 and index == 6 and object.modelId == 6 then return false end
        if slot7_selected.v ~= 0 and index == 7 and object.modelId == 7 then return false end
    end
end

function sampev.onSetPlayerSkin(playerId, skinId)
    if skin_enabled.v then return false end
end

--SKIN RESET FIX
function sampev.onSetPlayerPos(x,y,z)
    if skin_enabled.v then
	    if skinid.v then
	    	_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	    	set_player_skin(id, skinid.v)
	    end
    end
end

function sampev.onSendSpawn()
    apply()
end

--local item = {modelid, bone, offX, offY, offZ, rotX, rotY, rotZ, scaleX, scaleY, scaleZ}


function glowEffect()
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt16(bs, select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) -- playerId
    raknetBitStreamWriteInt32(bs, 6) -- index
    raknetBitStreamWriteBool(bs, true) -- create
    raknetBitStreamWriteInt32(bs, 1276) -- modelId
    raknetBitStreamWriteInt32(bs, 1) -- bone
    raknetBitStreamWriteFloat(bs, 0) -- offset x
    raknetBitStreamWriteFloat(bs, 0) -- offset y
    raknetBitStreamWriteFloat(bs, 0) -- offset z
    raknetBitStreamWriteFloat(bs, 0) -- rotation x
    raknetBitStreamWriteFloat(bs, 0) -- rotation y
    raknetBitStreamWriteFloat(bs, 0) -- rotation z
    raknetBitStreamWriteFloat(bs, 0.1) -- scale x
    raknetBitStreamWriteFloat(bs, 0) -- scale y
    raknetBitStreamWriteFloat(bs, 0.38999998569489) -- scale z
    raknetBitStreamWriteInt32(bs, -1) -- color1
    raknetBitStreamWriteInt32(bs, -1) -- color2
    raknetEmulRpcReceiveBitStream(113, bs)
    raknetDeleteBitStream(bs)
    local item = {modelid, bone, offX, offY, offZ, rotX, rotY, rotZ, scaleX, scaleY, scaleZ}
end

function slotApply(indexNumber, itemData)
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt16(bs, select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) -- playerId
    raknetBitStreamWriteInt32(bs, indexNumber) -- index
    raknetBitStreamWriteBool(bs,  true) -- create
    raknetBitStreamWriteInt32(bs, itemData[1]) -- modelId
    raknetBitStreamWriteInt32(bs, itemData[2]) -- bone
    raknetBitStreamWriteFloat(bs, itemData[3]) -- offset x
    raknetBitStreamWriteFloat(bs, itemData[4]) -- offset y
    raknetBitStreamWriteFloat(bs, itemData[5]) -- offset z
    raknetBitStreamWriteFloat(bs, itemData[6]) -- rotation x
    raknetBitStreamWriteFloat(bs, itemData[7]) -- rotation y
    raknetBitStreamWriteFloat(bs, itemData[8])  -- rotation z
    raknetBitStreamWriteFloat(bs, itemData[9]) -- scale x
    raknetBitStreamWriteFloat(bs, itemData[10]) -- scale y
    raknetBitStreamWriteFloat(bs, itemData[11]) -- scale z
    raknetBitStreamWriteInt32(bs, -1) -- color1
    raknetBitStreamWriteInt32(bs, -1) -- color2
    raknetEmulRpcReceiveBitStream(113, bs)
    raknetDeleteBitStream(bs)
end

function rollerFix()
    if getCharModel(PLAYER_PED) == 92 or getCharModel(PLAYER_PED) == 99 then
        if isKeyDown(87) then
            setCharAnimSpeed(PLAYER_PED, 'skate_idle', 1000)
        end
    end
end

function save()
    --SKIN
    ini.skin.enabled = skin_enabled.v
    ini.skin.skinid = skinid.v 
    ini.skin.skin_select_mode = skin_select_mode.v
    ini.skin.rollerFix = skin_rollerFix.v
    ini.skin.NormalSkinsTurn = skin_NormalSkinsTurn.v

    --SLOTS

    ini.slots.slot0 = slot0_selected.v
    ini.slots.slot1 = slot1_selected.v
    ini.slots.slot2 = slot2_selected.v
    ini.slots.slot3 = slot3_selected.v
    ini.slots.slot4 = slot4_selected.v
    ini.slots.slot5 = slot5_selected.v
    ini.slots.glow = glow.v
    ini.slots.case = case_selected.v

    inicfg.save(ini, directIni)
end

function onScriptTerminate(s, q)
    if s == thisScript() then
        save()
        for i = 1, 7 do clear(i) end
    end
end

function case_default()
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt16(bs, select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) -- playerId
    raknetBitStreamWriteInt32(bs, 7) -- index
    raknetBitStreamWriteBool(bs, true) -- create
    raknetBitStreamWriteInt32(bs, 1210) -- modelId
    raknetBitStreamWriteInt32(bs, 5) -- bone
    raknetBitStreamWriteFloat(bs, 0.29999899864197) -- offset x
    raknetBitStreamWriteFloat(bs, 0.099999003112316) -- offset y
    raknetBitStreamWriteFloat(bs, 0) -- offset z
    raknetBitStreamWriteFloat(bs, 0) -- rotation x
    raknetBitStreamWriteFloat(bs, -83) -- rotation y
    raknetBitStreamWriteFloat(bs, 0) -- rotation z
    raknetBitStreamWriteFloat(bs, 1) -- scale x
    raknetBitStreamWriteFloat(bs, 1) -- scale y
    raknetBitStreamWriteFloat(bs, 1) -- scale z
    raknetBitStreamWriteInt32(bs, -1) -- color1
    raknetBitStreamWriteInt32(bs, -1) -- color2
    raknetEmulRpcReceiveBitStream(113, bs)
    raknetDeleteBitStream(bs)
    local item = {modelid, bone, offX, offY, offZ, rotX, rotY, rotZ, scaleX, scaleY, scaleZ}
end

function case_laptop()
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt16(bs, select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) -- playerId
    raknetBitStreamWriteInt32(bs, 7) -- index
    raknetBitStreamWriteBool(bs, true) -- create
    raknetBitStreamWriteInt32(bs, 11745) -- modelId
    raknetBitStreamWriteInt32(bs, 5) -- bone
    raknetBitStreamWriteFloat(bs, 0.266999989748) -- offset x
    raknetBitStreamWriteFloat(bs, 0.026999000459909) -- offset y
    raknetBitStreamWriteFloat(bs, 0.029999999329448) -- offset z
    raknetBitStreamWriteFloat(bs, -2.5999989509583) -- rotation x
    raknetBitStreamWriteFloat(bs, -96.299926757813) -- rotation y
    raknetBitStreamWriteFloat(bs, 85.300010681152) -- rotation z
    raknetBitStreamWriteFloat(bs, 0.20799900591373) -- scale x
    raknetBitStreamWriteFloat(bs, 1) -- scale y
    raknetBitStreamWriteFloat(bs, 1.2519990205765) -- scale z
    raknetBitStreamWriteInt32(bs, -1) -- color1
    raknetBitStreamWriteInt32(bs, -1) -- color2
    raknetEmulRpcReceiveBitStream(113, bs)
    raknetDeleteBitStream(bs)
    local item = {modelid, bone, offX, offY, offZ, rotX, rotY, rotZ, scaleX, scaleY, scaleZ}
end

function case_red()
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt16(bs, select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) -- playerId
    raknetBitStreamWriteInt32(bs, 7) -- index
    raknetBitStreamWriteBool(bs,  true) -- create
    raknetBitStreamWriteInt32(bs, 19921) -- modelId
    raknetBitStreamWriteInt32(bs, 5) -- bone
    raknetBitStreamWriteFloat(bs, 0.1140000000596) -- offset x
    raknetBitStreamWriteFloat(bs, 0.040998999029398) -- offset y
    raknetBitStreamWriteFloat(bs, -0.044998999685049) -- offset z
    raknetBitStreamWriteFloat(bs, 93.100112915039) -- rotation x
    raknetBitStreamWriteFloat(bs, -12.099985122681) -- rotation y
    raknetBitStreamWriteFloat(bs, -75.89998626709)  -- rotation z
    raknetBitStreamWriteFloat(bs, 0.87099999189377) -- scale x
    raknetBitStreamWriteFloat(bs, 0.89899998903275) -- scale y
    raknetBitStreamWriteFloat(bs, 0.60199898481369) -- scale z
    raknetBitStreamWriteInt32(bs, -1) -- color1
    raknetBitStreamWriteInt32(bs, -1) -- color2
    raknetEmulRpcReceiveBitStream(113, bs)
    raknetDeleteBitStream(bs)
    local item = {modelid, bone, offX, offY, offZ, rotX, rotY, rotZ, scaleX, scaleY, scaleZ}
end

function theme()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2
  
  
    style.WindowPadding = ImVec2(6, 4)
    style.WindowRounding = 15.0
    style.FramePadding = ImVec2(5, 2)
    style.FrameRounding = 3.0
    style.ItemSpacing = ImVec2(7, 1)
    style.ItemInnerSpacing = ImVec2(1, 1)
    style.TouchExtraPadding = ImVec2(0, 0)
    style.IndentSpacing = 6.0
    style.ScrollbarSize = 12.0
    style.ScrollbarRounding = 16.0
    style.GrabMinSize = 20.0
    style.GrabRounding = 2.0
  
    style.WindowTitleAlign = ImVec2(0.5, 0.5)

    colors[clr.WindowBg] = ImVec4(0.13, 0.14, 0.17, 1.00)
    colors[clr.FrameBg] = ImVec4(0.200, 0.220, 0.270, 0.85)
    colors[clr.TitleBg] = ImVec4(1, 0, 0.3, 1.00)
    colors[clr.TitleBgActive] = ImVec4(1, 0, 0.3, 1.00)
    colors[clr.Button] = ImVec4(1, 0, 0.3, 1.00)
  end
theme()

function imgui.Link(link) -- by Cosmo 
    if status_hovered then
        local p = imgui.GetCursorScreenPos()
        imgui.TextColored(imgui.ImVec4(0, 0.5, 1, 1), link)
        imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x, p.y + imgui.CalcTextSize(link).y), imgui.ImVec2(p.x + imgui.CalcTextSize(link).x, p.y + imgui.CalcTextSize(link).y), imgui.GetColorU32(imgui.ImVec4(0, 0.5, 1, 1)))
    else
        imgui.TextColored(imgui.ImVec4(0, 0.3, 0.8, 1), link)
    end
    if imgui.IsItemClicked() then os.execute('explorer '..link)
    elseif imgui.IsItemHovered() then
        status_hovered = true else status_hovered = false
    end
end

function imgui.TextQuestion(text)
    imgui.SameLine()
    imgui.TextDisabled('?')
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450)
        imgui.TextUnformatted(text)
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end

function imgui.CenterTextColoredRGB(text)
    local width = imgui.GetWindowWidth()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local ImVec4 = imgui.ImVec4

    local explode_argb = function(argb)
        local a = bit.band(bit.rshift(argb, 24), 0xFF)
        local r = bit.band(bit.rshift(argb, 16), 0xFF)
        local g = bit.band(bit.rshift(argb, 8), 0xFF)
        local b = bit.band(argb, 0xFF)
        return a, r, g, b
    end

    local getcolor = function(color)
        if color:sub(1, 6):upper() == 'SSSSSS' then
            local r, g, b = colors[1].x, colors[1].y, colors[1].z
            local a = tonumber(color:sub(7, 8), 16) or colors[1].w * 255
            return ImVec4(r, g, b, a / 255)
        end
        local color = type(color) == 'string' and tonumber(color, 16) or color
        if type(color) ~= 'number' then return end
        local r, g, b, a = explode_argb(color)
        return imgui.ImColor(r, g, b, a):GetVec4()
    end

    local render_text = function(text_)
        for w in text_:gmatch('[^\r\n]+') do
            local textsize = w:gsub('{.-}', '')
            local text_width = imgui.CalcTextSize(u8(textsize))
            imgui.SetCursorPosX( width / 2 - text_width .x / 2 )
            local text, colors_, m = {}, {}, 1
            w = w:gsub('{(......)}', '{%1FF}')
            while w:find('{........}') do
                local n, k = w:find('{........}')
                local color = getcolor(w:sub(n + 1, k - 1))
                if color then
                    text[#text], text[#text + 1] = w:sub(m, n - 1), w:sub(k + 1, #w)
                    colors_[#colors_ + 1] = color
                    m = n
                end
                w = w:sub(1, n - 1) .. w:sub(k + 1, #w)
            end
            if text[0] then
                for i = 0, #text do
                    imgui.TextColored(colors_[i] or colors[1], u8(text[i]))
                    imgui.SameLine(nil, 0)
                end
                imgui.NewLine()
            else
                imgui.Text(u8(w))
            end
        end
    end
    render_text(text)
end

--test updated
