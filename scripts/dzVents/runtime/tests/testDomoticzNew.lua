local _ = require 'lodash'
_G._ = _

local scriptPath = ''

package.path = package.path .. ";../?.lua;" .. scriptPath .. '/?.lua'

local testData = require('tstData')

describe('#onlyDomoticz', function()
	local Domoticz, domoticz, settings, d1, d2, d3, d4

	setup(function()
		_G.TESTMODE = true

		_G.timeofday = {
			Daytime = 'dt',
			Nighttime = 'nt',
			SunriseInMinutes = 'sunrisemin',
			SunsetInMinutes = 'sunsetmin'
		}

		_G.globalvariables = {
			Security = 'sec',
			['script_reason'] = 'device',
			['script_path'] = scriptPath
		}

		_G.domoticzData = testData.domoticzData

		settings = {
			['Domoticz ip'] = '10.0.0.8',
			['Domoticz port'] = '8080',
			['Fetch interval'] = 'every 30 minutes',
			['Enable http fetch'] = true,
			['Log level'] = 2
		}

		Domoticz = require('Domoticz')


	end)

	teardown(function()
		Domoticz = nil
		domoticz = nil
	end)

	before_each(function()
		domoticz = Domoticz(settings)
		d1 = domoticz.devices['device1']
		d2 = domoticz.devices['device2']
		d3 = domoticz.devices['device3']
		d4 = domoticz.devices['device4']
	end)

	after_each(function()
		domoticz = nil
	end)

	it('should instantiate', function()
		assert.is_not_nil(domoticz)

		domoticz.logDevice(domoticz.devices['device1'])
	end)

	describe('properties', function()
		it('should have time properties', function()
			local now = os.date('*t')
			assert.is_same(domoticz.time.isDayTime, 'dt')
			assert.is_same(domoticz.time.isNightTime, 'nt')
			assert.is_same(domoticz.time.sunriseInMinutes, 'sunrisemin')
			assert.is_same(domoticz.time.sunsetInMinutes, 'sunsetmin')
			-- check for basic time props
			assert.is_same(now.hour, domoticz.time.hour)
		end)

		it('should have settings', function()
			assert.is_equal(domoticz.settings, settings)
		end)

		it('should have security info', function()
			assert.is_same('sec', domoticz.security)
		end)

		it('should have priority constants', function()
			assert.is_same(domoticz['PRIORITY_LOW'], -2)
			assert.is_same(domoticz['PRIORITY_MODERATE'], -1)
			assert.is_same(domoticz['PRIORITY_NORMAL'], 0)
			assert.is_same(domoticz['PRIORITY_HIGH'], 1)
			assert.is_same(domoticz['PRIORITY_EMERGENCY'], 2)
		end)

		it('should have sound constants', function()
			assert.is_same(domoticz['SOUND_DEFAULT'], 'pushover')
			assert.is_same(domoticz['SOUND_BIKE'], 'bike')
			assert.is_same(domoticz['SOUND_BUGLE'], 'bugle')
			assert.is_same(domoticz['SOUND_CASH_REGISTER'], 'cashregister')
			assert.is_same(domoticz['SOUND_CLASSICAL'], 'classical')
			assert.is_same(domoticz['SOUND_COSMIC'], 'cosmic')
			assert.is_same(domoticz['SOUND_FALLING'], 'falling')
			assert.is_same(domoticz['SOUND_GAMELAN'], 'gamelan')
			assert.is_same(domoticz['SOUND_INCOMING'], 'incoming')
			assert.is_same(domoticz['SOUND_INTERMISSION'], 'intermission')
			assert.is_same(domoticz['SOUND_MAGIC'], 'magic')
			assert.is_same(domoticz['SOUND_MECHANICAL'], 'mechanical')
			assert.is_same(domoticz['SOUND_PIANOBAR'], 'pianobar')
			assert.is_same(domoticz['SOUND_SIREN'], 'siren')
			assert.is_same(domoticz['SOUND_SPACEALARM'], 'spacealarm')
			assert.is_same(domoticz['SOUND_TUGBOAT'], 'tugboat')
			assert.is_same(domoticz['SOUND_ALIEN'], 'alien')
			assert.is_same(domoticz['SOUND_CLIMB'], 'climb')
			assert.is_same(domoticz['SOUND_PERSISTENT'], 'persistent')
			assert.is_same(domoticz['SOUND_ECHO'], 'echo')
			assert.is_same(domoticz['SOUND_UPDOWN'], 'updown')
			assert.is_same(domoticz['SOUND_NONE'], 'none')
		end)

		it('should have humidity constants', function()
			assert.is_same(domoticz['HUM_NORMAL'], 0)
			assert.is_same(domoticz['HUM_COMFORTABLE'], 1)
			assert.is_same(domoticz['HUM_DRY'], 2)
			assert.is_same(domoticz['HUM_WET'], 3)
		end)

		it('should have barometer constants', function()
			assert.is_same(domoticz['BARO_STABLE'], 0)
			assert.is_same(domoticz['BARO_SUNNY'], 1)
			assert.is_same(domoticz['BARO_CLOUDY'], 2)
			assert.is_same(domoticz['BARO_UNSTABLE'], 3)
			assert.is_same(domoticz['BARO_THUNDERSTORM'], 4)
			assert.is_same(domoticz['BARO_UNKNOWN'], 5)
			assert.is_same(domoticz['BARO_CLOUDY_RAIN'], 6)
		end)

		it('should have alert level constants', function()
			assert.is_same(domoticz['ALERTLEVEL_GREY'], 0)
			assert.is_same(domoticz['ALERTLEVEL_GREEN'], 1)
			assert.is_same(domoticz['ALERTLEVEL_YELLOW'], 2)
			assert.is_same(domoticz['ALERTLEVEL_ORANGE'], 3)
			assert.is_same(domoticz['ALERTLEVEL_RED'], 4)
		end)

		it('should have security constants', function()
			assert.is_same(domoticz['SECURITY_DISARMED'], 'Disarmed')
			assert.is_same(domoticz['SECURITY_ARMEDAWAY'], 'Armed Away')
			assert.is_same(domoticz['SECURITY_ARMEDHOME'], 'Armed Home')
		end)

		it('should have log constants', function()
			assert.is_same(domoticz['LOG_INFO'], 2)
			assert.is_same(domoticz['LOG_DEBUG'], 3)
			assert.is_same(domoticz['LOG_ERROR'], 1)
		end)
	end)

	describe('commands', function()
		it('should send commands', function()
			local res, command, value = domoticz.sendCommand('do', 'it')
			assert.is_same('do', command)
			assert.is_same('it', value)
			assert.is_same({ ['do'] = 'it' }, res)
		end)

		it('should send multiple commands', function()
			domoticz.sendCommand('do', 'it')
			domoticz.sendCommand('and', 'some more')
			assert.is_same({ { ["do"] = "it" }, { ["and"] = "some more" } }, domoticz.commandArray)
		end)

		it('should return a reference to a commandArray item', function()
			local res = domoticz.sendCommand('do', 'it')
			domoticz.sendCommand('and', 'some more')
			-- now change it
			res['do'] = 'cancel it'
			assert.is_same({ { ["do"] = "cancel it" }, { ["and"] = "some more" } }, domoticz.commandArray)
		end)

		it('should notify', function()
			domoticz.notify('sub', 'mes', 1, 'noise')
			assert.is_same({ { ['SendNotification'] = 'sub#mes#1#noise' } }, domoticz.commandArray)
		end)

		it('should notify with defaults', function()
			domoticz.notify('sub')
			assert.is_same({ { ['SendNotification'] = 'sub##0#pushover' } }, domoticz.commandArray)
		end)

		it('should send email', function()
			domoticz.email('sub', 'mes', 'to@someone')
			assert.is_same({ { ['SendEmail'] = 'sub#mes#to@someone' } }, domoticz.commandArray)
		end)

		it('should send sms', function()
			domoticz.sms('mes')
			assert.is_same({ { ['SendSMS'] = 'mes' } }, domoticz.commandArray)
		end)

		it('should open a url', function()
			domoticz.openURL('some url')
			assert.is_same({ { ['OpenURL'] = 'some url' } }, domoticz.commandArray)
		end)

		it('should set a scene', function()
			local res = domoticz.setScene('scene1', 'on')
			assert.is_table(res)
			assert.is_same({ { ['Scene:scene1'] = 'on' } }, domoticz.commandArray)
		end)

		it('should switch a group', function()
			local res = domoticz.switchGroup('group1', 'on')
			assert.is_table(res)
			assert.is_same({ { ['Group:group1'] = 'on' } }, domoticz.commandArray)
		end)
	end)

	describe('devices', function()

		it('should create devices', function()
			assert.is_not_nil(d1)
			assert.is_not_nil(d2)
			assert.is_not_nil(d3)
			assert.is_not_nil(d4)
		end)

		it('should have set their ids', function()
			assert.is_same(1, d1.id)
			assert.is_same(2, d2.id)
			assert.is_same(3, d3.id)
			assert.is_same(4, d4.id)
		end)

		it('should have set value extentions', function()
			assert.is_same(37, d1.temperature)
			assert.is_same(12, d2.temperature)
			assert.is_same(55, d1.dewpoint)
			assert.is_same(66, d2.dewpoint)
			assert.is_same(66, d1.humidity)
			assert.is_same(67, d2.humidity)
			assert.is_same(333, d4.barometer)
			assert.is_same(123, d4.utility)
			assert.is_same('Nice', d4.weather)
			assert.is_same(666, d4.rain)
			assert.is_same(12, d4.rainLastHour)
			assert.is_same(23, d3.uv)
		end)

		it('should have set last update info', function()
			assert.is_same('2016-03-20 12:23:00', d1.lastUpdate.raw)
			assert.is_same('2016-03-20 12:23:00', d2.lastUpdate.raw)
			assert.is_same('2016-03-20 12:23:00', d3.lastUpdate.raw)
			assert.is_same('2016-03-20 12:23:00', d4.lastUpdate.raw)
		end)

		it('should have set rawData', function()
			assert.is_same({ '1', '2', '3' }, d1.rawData)
			assert.is_same({ '4', '5', '6' }, d2.rawData)
			assert.is_same({ '7', '8', '9', '10', '11' }, d3.rawData)
			assert.is_same({ '10', '11', '12' }, d4.rawData)
		end)

		it('should have created id entries', function()
			assert.is_equal(d1, domoticz.devices[1])
			assert.is_equal(d2, domoticz.devices[2])
			assert.is_equal(d3, domoticz.devices[3])
			assert.is_equal(d4, domoticz.devices[4])
		end)

		it('should have created changedDevices collection', function()
			assert.is_equal(d1, domoticz.changedDevices[1])
			assert.is_equal(d2, domoticz.changedDevices[2])
			assert.is_equal(d1, domoticz.changedDevices['device1'])
			assert.is_equal(d2, domoticz.changedDevices['device2'])
			assert.is_nil(domoticz.changedDevices[3])
			assert.is_nil(domoticz.changedDevices[4])
			assert.is_nil(domoticz.changedDevices['device3'])
			assert.is_nil(domoticz.changedDevices['device4'])
		end)

		it('should have created a text device', function()
			assert.is_same('device8', domoticz.devices['device8'].name)
		end)
	end)

	it('should have created iterators', function()
		assert.is_function(domoticz.devices.forEach)
		assert.is_function(domoticz.devices.filter)
		assert.is_function(domoticz.devices.filter(function()
		end).forEach)

		assert.is_function(domoticz.changedDevices.forEach)
		assert.is_function(domoticz.changedDevices.filter)
		assert.is_function(domoticz.changedDevices.filter(function()
		end).forEach)

		assert.is_function(domoticz.variables.forEach)
		assert.is_function(domoticz.variables.filter)
		assert.is_function(domoticz.variables.filter(function()
		end).forEach)
	end)

	it('should have a working filter and foreach', function()
		local devices = {}
		domoticz.devices.filter(function(d)
			return (d.id == 1 or d.id == 3)
		end).forEach(function(d)
			table.insert(devices, d.id)
		end)

		table.sort(devices)
		assert.is_same({ 1, 3 }, devices)
	end)

	it('should have created variables', function()
		assert.is_same(1, domoticz.variables['x'].nValue)
		assert.is_same(2, domoticz.variables['y'].nValue)
	end)

	it('should have created scenes', function()
		assert.is_same({ 1, 2, 'Scene1', 'Scene2', 'filter', 'forEach' }, _.keys(domoticz.scenes))
		assert.is_same({ 'Scene1', 'Scene2', 'Scene1', 'Scene2' }, _.pluck(domoticz.scenes, { 'name' }))
		assert.is_same({ 'Off', 'Off', 'Off', 'Off' }, _.pluck(domoticz.scenes, { 'state' }))
	end)

	it('should have created groups', function()
		assert.is_same({ 3, 4, 'Group1', 'Group2', 'filter', 'forEach' }, _.keys(domoticz.groups))
		assert.is_same({ 'Group1', 'Group2', 'Group1', 'Group2' }, _.pluck(domoticz.groups, { 'name' }))
		assert.is_same({ 'On', 'Mixed', 'On', 'Mixed' }, _.pluck(domoticz.groups, { 'state' }))
	end)

	it('should log', function()
		local utils = domoticz._getUtilsInstance()
		local logged = false

		utils.log = function(msg, level)
			logged = true
		end

		domoticz.log('boeh', 1)
		assert.is_true(logged)
	end)

	it('should have processed http data', function()
		assert.is_same(10, d1.batteryLevel)
		assert.is_same(20, d2.batteryLevel)
		assert.is_same(30, d3.batteryLevel)
		assert.is_same(40, d4.batteryLevel)
		assert.is_same('Description 1', d1.description)
		assert.is_same('Description 2', d2.description)
		assert.is_same('Description 3', d3.description)
		assert.is_same('Description 4', d4.description)

		assert.is_same('10', d1.signalLevel)
		assert.is_same('20', d2.signalLevel)
		assert.is_same('30', d3.signalLevel)
		assert.is_same('-', d4.signalLevel)

		assert.is_same('Zone', d1.deviceSubType)
		assert.is_same('Lux', d2.deviceSubType)
		assert.is_same('Energy', d3.deviceSubType)
		assert.is_same('SetPoint', d4.deviceSubType)

		assert.is_same('Heating', d1.deviceType)
		assert.is_same('Lux', d2.deviceType)
		assert.is_same('P1 Smart Meter', d3.deviceType)
		assert.is_same('Thermostat', d4.deviceType)

		assert.is_same('hw1', d1.hardwareName)
		assert.is_same('hw2', d2.hardwareName)
		assert.is_same('hw3', d3.hardwareName)
		assert.is_same('hw4', d4.hardwareName)

		assert.is_same('ht1', d1.hardwareType)
		assert.is_same('ht2', d2.hardwareType)
		assert.is_same('ht3', d3.hardwareType)
		assert.is_same('ht4', d4.hardwareType)

		assert.is_same(1, d1.hardwareId)
		assert.is_same(2, d2.hardwareId)
		assert.is_same(3, d3.hardwareId)
		assert.is_same(4, d4.hardwareId)

		assert.is_same(1, d1.hardwareTypeVal)
		assert.is_same(2, d2.hardwareTypeVal)
		assert.is_same(3, d3.hardwareTypeVal)
		assert.is_same(4, d4.hardwareTypeVal)

		assert.is_same('Contact', d1.switchType)
		assert.is_same('Motion Sensor', d2.switchType)
		assert.is_same('On/Off', d3.switchType)
		assert.is_same('Security', d4.switchType)

		assert.is_same(2, d1.switchTypeValue)
		assert.is_same(8, d2.switchTypeValue)
		assert.is_same(0, d3.switchTypeValue)
		assert.is_same(0, d4.switchTypeValue)

		assert.is_true(d1.timedOut)
		assert.is_false(d2.timedOut)
		assert.is_false(d3.timedOut)
		assert.is_false(d4.timedOut)

		assert.is_same(2, d1.setPoint)
		assert.is_same('3', d1.heatingMode)

		assert.is_same(4, d2.lux)

		local d5 = domoticz.devices['device5']
		assert.is_same(14, d5.WhTotal)
		assert.is_same(1.234, d5.WhToday)
		assert.is_same(13, d5.WActual)
		assert.is_same('1.234 kWh', d5.counterToday)
		assert.is_same('567 kWh', d5.counterTotal)
		assert.is_same(10, d5.level)

		assert.is_same(11, d3.WActual)

		assert.is_same(10, d4.setPoint)

		local d7 = domoticz.devices['device7']
		assert.is_same(16.5, d7.WActual)
	end)
end)