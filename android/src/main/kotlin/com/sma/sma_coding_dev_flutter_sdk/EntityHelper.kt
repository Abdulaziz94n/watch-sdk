package com.sma.sma_coding_dev_flutter_sdk

import com.bestmafen.baseble.scanner.BleDevice
import com.szabh.smable3.entity.*
import org.json.JSONObject
import java.lang.Exception

/**
 * 杰里设备是否ota模式
 */
fun isJLOTA(device: BleDevice): Boolean {
    try {
        val bytes = device.mScanRecord ?: ByteArray(20)
        if (bytes.size > 20) {
            return String(bytes.copyOfRange(4,9).reversed().toByteArray()) == "JLOTA"
        }
    } catch (e: Exception) {
        e.printStackTrace()
    }
    return false
}

object BleDeviceHelper {
    fun toJson(device: BleDevice): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mName"] = device.mName
        data["mAddress"] = device.mBluetoothDevice.address
        data["mRssi"] = device.mRssi
        data["isDfu"] = isJLOTA(device)
        return data
    }
}

object BleDeviceInfoHelper {
    fun toJson(deviceInfo: BleDeviceInfo): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mId"] = deviceInfo.mId
        data["mDataKeys"] = deviceInfo.mDataKeys
        data["mBleName"] = deviceInfo.mBleName
        data["mBleAddress"] = deviceInfo.mBleAddress
        data["mPlatform"] = deviceInfo.mPlatform
        data["mPrototype"] = deviceInfo.mPrototype
        data["mFirmwareFlag"] = deviceInfo.mFirmwareFlag
        data["mAGpsType"] = deviceInfo.mAGpsType
        data["mIOBufferSize"] = deviceInfo.mIOBufferSize
        data["mWatchFaceType"] = deviceInfo.mWatchFaceType
        data["mClassicAddress"] = deviceInfo.mClassicAddress
        data["mHideDigitalPower"] = deviceInfo.mHideDigitalPower
        data["mShowAntiLostSwitch"] = deviceInfo.mShowAntiLostSwitch
        data["mSleepAlgorithmType"] = deviceInfo.mSleepAlgorithmType
        data["mSupportDateFormatSet"] = deviceInfo.mSupportDateFormatSet
        data["mSupportReadDeviceInfo"] = deviceInfo.mSupportReadDeviceInfo
        data["mSupportTemperatureUnitSet"] = deviceInfo.mSupportTemperatureUnitSet
        data["mSupportDrinkWaterSet"] = deviceInfo.mSupportDrinkWaterSet
        data["mSupportChangeClassicBluetoothState"] = deviceInfo.mSupportChangeClassicBluetoothState
        data["mSupportAppSport"] = deviceInfo.mSupportAppSport
        data["mSupportBloodOxyGenSet"] = deviceInfo.mSupportBloodOxyGenSet
        data["mSupportWashSet"] = deviceInfo.mSupportWashSet
        data["mSupportRequestRealtimeWeather"] = deviceInfo.mSupportRequestRealtimeWeather
        data["mSupportHID"] = deviceInfo.mSupportHID
        data["mSupportIBeaconSet"] = deviceInfo.mSupportIBeaconSet
        data["mSupportWatchFaceId"] = deviceInfo.mSupportWatchFaceId
        data["mSupportNewTransportMode"] = deviceInfo.mSupportNewTransportMode
        data["mSupportJLTransport"] = deviceInfo.mSupportJLTransport
        data["mSupportFindWatch"] = deviceInfo.mSupportFindWatch
        data["mSupportWorldClock"] = deviceInfo.mSupportWorldClock
        data["mSupportStock"] = deviceInfo.mSupportStock
        data["mSupportSMSQuickReply"] = deviceInfo.mSupportSMSQuickReply
        data["mSupportNoDisturbSet"] = deviceInfo.mSupportNoDisturbSet
        data["mSupportSetWatchPassword"] = deviceInfo.mSupportSetWatchPassword
        data["mSupportRealTimeMeasurement"] = deviceInfo.mSupportRealTimeMeasurement
        data["mSupportPowerSaveMode"] = deviceInfo.mSupportPowerSaveMode
        data["mSupportLoveTap"] = deviceInfo.mSupportLoveTap
        data["mSupportNewsfeed"] = deviceInfo.mSupportNewsfeed
        data["mSupportMedicationReminder"] = deviceInfo.mSupportMedicationReminder
        data["mSupportQrcode"] = deviceInfo.mSupportQrcode
        data["mSupportWeather2"] = deviceInfo.mSupportWeather2
        data["mSupportAlipay"] = deviceInfo.mSupportAlipay
        data["mSupportStandbySet"] = deviceInfo.mSupportStandbySet
        data["mSupport2DAcceleration"] = deviceInfo.mSupport2DAcceleration
        data["mSupportTuyaKey"] = deviceInfo.mSupportTuyaKey
        data["mSupportMedicationAlarm"] = deviceInfo.mSupportMedicationAlarm
        data["mSupportReadPackageStatus"] = deviceInfo.mSupportReadPackageStatus
        data["mSupportContactSize"] = deviceInfo.mSupportContactSize
        data["mSupportVoice"] = deviceInfo.mSupportVoice
        data["mSupportNavigation"] = deviceInfo.mSupportNavigation
        data["mSupportHrWarnSet"] = deviceInfo.mSupportHrWarnSet
        data["mSupportMusicTransfer"] = deviceInfo.mSupportMusicTransfer
        data["mSupportNoDisturbSet2"] = deviceInfo.mSupportNoDisturbSet2
        data["mSupportSOSSet"] = deviceInfo.mSupportSOSSet
        data["mSupportReadLanguages"] = deviceInfo.mSupportReadLanguages
        data["mSupportGirlCareReminder"] = deviceInfo.mSupportGirlCareReminder
        data["mSupportAppPushSwitch"] = deviceInfo.mSupportAppPushSwitch
        data["mSupportReceiptCodeSize"] = deviceInfo.mSupportReceiptCodeSize
        data["mSupportGameTimeReminder"] = deviceInfo.mSupportGameTimeReminder
        data["mSupportMyCardCodeSize"] = deviceInfo.mSupportMyCardCodeSize
        data["mSupportDeviceSportData"] = deviceInfo.mSupportDeviceSportData
        data["mSupportEbookTransfer"] = deviceInfo.mSupportEbookTransfer
        data["mSupportDoubleScreen"] = deviceInfo.mSupportDoubleScreen
        data["mSupportCustomLogo"] = deviceInfo.mSupportCustomLogo
        data["mSupportPressureTimingMeasurement"] = deviceInfo.mSupportPressureTimingMeasurement
        data["mSupportTimerStandbySet"] = deviceInfo.mSupportTimerStandbySet
        data["mSupportSOSSet2"] = deviceInfo.mSupportSOSSet2
        data["mSupportFallSet"] = deviceInfo.mSupportFallSet
        data["mSupportWalkAndBike"] = deviceInfo.mSupportWalkAndBike
        data["mSupportConnectReminder"] = deviceInfo.mSupportConnectReminder
        data["mSupportSDCardInfo"] = deviceInfo.mSupportSDCardInfo
        data["mSupportIncomingCallRing"] = deviceInfo.mSupportIncomingCallRing
        data["mSupportNotificationLightScreenSet"] = deviceInfo.mSupportNotificationLightScreenSet
        data["mSupportBloodPressureCalibration"] = deviceInfo.mSupportBloodPressureCalibration
        data["mSupportOTAFile"] = deviceInfo.mSupportOTAFile
        return data
    }
}

object BleActivityHelper {
    fun toJson(obj: BleActivity): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mTime"] = obj.mTime
        data["mMode"] = obj.mMode
        data["mStep"] = obj.mStep
        data["mState"] = obj.mState
        data["mCalorie"] = obj.mCalorie
        data["mDistance"] = obj.mDistance
        return data
    }

    fun listToJson(datas: List<BleActivity>): List<Map<String, Any>> {
        val list = mutableListOf<Map<String, Any>>()
        datas.forEach {
            list.add(toJson(it))
        }
        return list
    }
}

object BleAlarmHelper {
    fun fromJson(json: JSONObject): BleAlarm {
        val alarm = BleAlarm()
        alarm.mId = json.getInt("mId")
        alarm.mEnabled = json.getInt("mEnabled")
        alarm.mRepeat = json.getInt("mRepeat")
        alarm.mYear = json.getInt("mYear")
        alarm.mMonth = json.getInt("mMonth")
        alarm.mDay = json.getInt("mDay")
        alarm.mHour = json.getInt("mHour")
        alarm.mMinute = json.getInt("mMinute")
        alarm.mTag = json.getString("mTag")
        return alarm
    }

    fun toJson(obj: BleAlarm): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mId"] = obj.mId
        data["mEnabled"] = obj.mEnabled
        data["mRepeat"] = obj.mRepeat
        data["mYear"] = obj.mYear
        data["mMonth"] = obj.mMonth
        data["mDay"] = obj.mDay
        data["mHour"] = obj.mHour
        data["mMinute"] = obj.mMinute
        data["mTag"] = obj.mTag
        return data
    }

    fun listToJson(datas: List<BleAlarm>): List<Map<String, Any>> {
        val list = mutableListOf<Map<String, Any>>()
        datas.forEach {
            list.add(toJson(it))
        }
        return list
    }
}

object BleBloodOxygenHelper {
    fun toJson(obj: BleBloodOxygen): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mTime"] = obj.mTime
        data["mValue"] = obj.mValue
        return data
    }

    fun listToJson(datas: List<BleBloodOxygen>): List<Map<String, Any>> {
        val list = mutableListOf<Map<String, Any>>()
        datas.forEach {
            list.add(toJson(it))
        }
        return list
    }
}

object BleBloodPressureHelper {
    fun toJson(obj: BleBloodPressure): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mTime"] = obj.mTime
        data["mSystolic"] = obj.mSystolic
        data["mDiastolic"] = obj.mDiastolic
        return data
    }

    fun listToJson(datas: List<BleBloodPressure>): List<Map<String, Any>> {
        val list = mutableListOf<Map<String, Any>>()
        datas.forEach {
            list.add(toJson(it))
        }
        return list
    }
}

object BleHeartRateHelper {
    fun toJson(obj: BleHeartRate): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mTime"] = obj.mTime
        data["mBpm"] = obj.mBpm
        return data
    }

    fun listToJson(datas: List<BleHeartRate>): List<Map<String, Any>> {
        val list = mutableListOf<Map<String, Any>>()
        datas.forEach {
            list.add(toJson(it))
        }
        return list
    }
}

object BleHrvHelper {
    fun toJson(obj: BleHrv): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mTime"] = obj.mTime
        data["mValue"] = obj.mValue
        data["mAvgValue"] = obj.mAvgValue
        return data
    }

    fun listToJson(datas: List<BleHrv>): List<Map<String, Any>> {
        val list = mutableListOf<Map<String, Any>>()
        datas.forEach {
            list.add(toJson(it))
        }
        return list
    }
}

object BleLanguagePackVersionHelper {
    fun toJson(obj: BleLanguagePackVersion): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mVersion"] = obj.mVersion
        data["mLanguageCode"] = obj.mLanguageCode
        return data
    }
}

object BleLocationHelper {
    fun toJson(obj: BleLocation): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mTime"] = obj.mTime
        data["mActivityMode"] = obj.mActivityMode
        data["mAltitude"] = obj.mAltitude
        data["mLongitude"] = obj.mLongitude
        data["mLatitude"] = obj.mLatitude
        return data
    }

    fun listToJson(datas: List<BleLocation>): List<Map<String, Any>> {
        val list = mutableListOf<Map<String, Any>>()
        datas.forEach {
            list.add(toJson(it))
        }
        return list
    }
}

object BleTimeRangeHelper {
    fun toJson(obj: BleTimeRange): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mEnabled"] = obj.mEnabled
        data["mStartHour"] = obj.mStartHour
        data["mStartMinute"] = obj.mStartMinute
        data["mEndHour"] = obj.mEndHour
        data["mEndMinute"] = obj.mEndMinute
        return data
    }

    fun fromJson(json: JSONObject): BleTimeRange {
        val timeRange = BleTimeRange()
        timeRange.mEnabled = json.getInt("mEnabled")
        timeRange.mStartHour = json.getInt("mStartHour")
        timeRange.mStartMinute = json.getInt("mStartMinute")
        timeRange.mEndHour = json.getInt("mEndHour")
        timeRange.mEndMinute = json.getInt("mEndMinute")
        return timeRange
    }
}

object BleUserProfileHelper {
    fun toJson(obj: BleUserProfile): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mUnit"] = obj.mUnit
        data["mGender"] = obj.mGender
        data["mAge"] = obj.mAge
        data["mHeight"] = obj.mHeight
        data["mWeight"] = obj.mWeight
        return data
    }

    fun fromJson(json: JSONObject): BleUserProfile {
        val userProfile = BleUserProfile()
        userProfile.mUnit = json.getInt("mUnit")
        userProfile.mGender = json.getInt("mGender")
        userProfile.mAge = json.getInt("mAge")
        userProfile.mHeight = json.getDouble("mHeight").toFloat()
        userProfile.mWeight = json.getDouble("mWeight").toFloat()
        return userProfile
    }
}

object BlePressureHelper {
    fun toJson(obj: BlePressure): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mTime"] = obj.mTime
        data["mValue"] = obj.mValue
        return data
    }

    fun listToJson(datas: List<BlePressure>): List<Map<String, Any>> {
        val list = mutableListOf<Map<String, Any>>()
        datas.forEach {
            list.add(toJson(it))
        }
        return list
    }
}

object BleTemperatureHelper {
    fun toJson(obj: BleTemperature): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mTime"] = obj.mTime
        data["mTemperature"] = obj.mTemperature
        return data
    }

    fun listToJson(datas: List<BleTemperature>): List<Map<String, Any>> {
        val list = mutableListOf<Map<String, Any>>()
        datas.forEach {
            list.add(toJson(it))
        }
        return list
    }
}

object BleWorkoutHelper {
    fun toJson(obj: BleWorkout): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mStart"] = obj.mStart
        data["mEnd"] = obj.mEnd
        data["mDuration"] = obj.mDuration
        data["mAltitude"] = obj.mAltitude
        data["mAirPressure"] = obj.mAirPressure
        data["mSpm"] = obj.mSpm
        data["mMode"] = obj.mMode
        data["mStep"] = obj.mStep
        data["mDistance"] = obj.mDistance
        data["mCalorie"] = obj.mCalorie
        data["mSpeed"] = obj.mSpeed
        data["mPace"] = obj.mPace
        data["mAvgBpm"] = obj.mAvgBpm
        data["mMaxBpm"] = obj.mMaxBpm
        return data
    }

    fun listToJson(datas: List<BleWorkout>): List<Map<String, Any>> {
        val list = mutableListOf<Map<String, Any>>()
        datas.forEach {
            list.add(toJson(it))
        }
        return list
    }
}

object BleWorkout2Helper {
    fun toJson(obj: BleWorkout2): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mStart"] = obj.mStart
        data["mEnd"] = obj.mEnd
        data["mDuration"] = obj.mDuration
        data["mAltitude"] = obj.mAltitude
        data["mAirPressure"] = obj.mAirPressure
        data["mSpm"] = obj.mSpm
        data["mMode"] = obj.mMode
        data["mStep"] = obj.mStep
        data["mDistance"] = obj.mDistance
        data["mCalorie"] = obj.mCalorie
        data["mSpeed"] = obj.mSpeed
        data["mPace"] = obj.mPace
        data["mAvgBpm"] = obj.mAvgBpm
        data["mMaxBpm"] = obj.mMaxBpm
        data["mMinBpm"] = obj.mMinBpm
        data["mMaxSpm"] = obj.mMaxSpm
        data["mMinSpm"] = obj.mMinSpm
        data["mMaxPace"] = obj.mMaxPace
        data["mMinPace"] = obj.mMinPace
        return data
    }

    fun listToJson(datas: List<BleWorkout2>): List<Map<String, Any>> {
        val list = mutableListOf<Map<String, Any>>()
        datas.forEach {
            list.add(toJson(it))
        }
        return list
    }
}

object BleSedentarinessSettingsHelper {
    fun fromJson(json: JSONObject): BleSedentarinessSettings {
        val sedentarinessSettings = BleSedentarinessSettings()
        sedentarinessSettings.mEnabled = json.getInt("mEnabled")
        sedentarinessSettings.mRepeat = json.getInt("mRepeat")
        sedentarinessSettings.mStartHour = json.getInt("mStartHour")
        sedentarinessSettings.mStartMinute = json.getInt("mStartMinute")
        sedentarinessSettings.mEndHour = json.getInt("mEndHour")
        sedentarinessSettings.mEndMinute = json.getInt("mEndMinute")
        sedentarinessSettings.mInterval = json.getInt("mInterval")
        return sedentarinessSettings
    }

    fun toJson(obj: BleSedentarinessSettings): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mEnabled"] = obj.mEnabled
        data["mRepeat"] = obj.mRepeat
        data["mStartHour"] = obj.mStartHour
        data["mStartMinute"] = obj.mStartMinute
        data["mEndHour"] = obj.mEndHour
        data["mEndMinute"] = obj.mEndMinute
        data["mInterval"] = obj.mInterval
        return data
    }
}

object BleNoDisturbSettingsHelper {
    fun fromJson(json: JSONObject): BleNoDisturbSettings {
        val noDisturbSettings = BleNoDisturbSettings()
        noDisturbSettings.mEnabled = json.getInt("mEnabled")
        noDisturbSettings.mBleTimeRange1 = BleTimeRangeHelper.fromJson(json.getJSONObject("mBleTimeRange1"))
        noDisturbSettings.mBleTimeRange2 = BleTimeRangeHelper.fromJson(json.getJSONObject("mBleTimeRange2"))
        noDisturbSettings.mBleTimeRange3 = BleTimeRangeHelper.fromJson(json.getJSONObject("mBleTimeRange3"))
        return noDisturbSettings
    }

    fun toJson(obj: BleNoDisturbSettings): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mEnabled"] = obj.mEnabled
        data["mBleTimeRange1"] = BleTimeRangeHelper.toJson(obj.mBleTimeRange1)
        data["mBleTimeRange2"] = BleTimeRangeHelper.toJson(obj.mBleTimeRange2)
        data["mBleTimeRange3"] = BleTimeRangeHelper.toJson(obj.mBleTimeRange3)
        return data
    }
}

object BleGestureWakeHelper {
    fun fromJson(json: JSONObject): BleGestureWake {
        val gestureWake = BleGestureWake()
        gestureWake.mBleTimeRange = BleTimeRangeHelper.fromJson(json.getJSONObject("mBleTimeRange"))
        return gestureWake
    }

    fun toJson(obj: BleGestureWake): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mBleTimeRange"] = BleTimeRangeHelper.toJson(obj.mBleTimeRange)
        return data
    }
}

object BleSleepHelper {
    fun toJson(obj: BleSleep): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mTime"] = obj.mTime
        data["mMode"] = obj.mMode
        data["mSoft"] = obj.mSoft
        data["mStrong"] = obj.mStrong
        return data
    }

    fun listToJson(datas: List<BleSleep>): List<Map<String, Any>> {
        val list = mutableListOf<Map<String, Any>>()
        datas.forEach {
            list.add(toJson(it))
        }
        return list
    }
}

object BleGirlCareSettingsHelper {
    fun fromJson(json: JSONObject): BleGirlCareSettings {
        val girlCareSettings = BleGirlCareSettings()
        girlCareSettings.mEnabled = json.getInt("mEnabled")
        girlCareSettings.mReminderHour = json.getInt("mReminderHour")
        girlCareSettings.mReminderMinute = json.getInt("mReminderMinute")
        girlCareSettings.mMenstruationReminderAdvance = json.getInt("mMenstruationReminderAdvance")
        girlCareSettings.mOvulationReminderAdvance = json.getInt("mOvulationReminderAdvance")
        girlCareSettings.mLatestYear = json.getInt("mLatestYear")
        girlCareSettings.mLatestMonth = json.getInt("mLatestMonth")
        girlCareSettings.mLatestDay = json.getInt("mLatestDay")
        girlCareSettings.mMenstruationDuration = json.getInt("mMenstruationDuration")
        girlCareSettings.mMenstruationPeriod = json.getInt("mMenstruationPeriod")
        return girlCareSettings
    }
}

object BleNotificationHelper {
    fun fromJson(json: JSONObject): BleNotification {
        val notification = BleNotification()
        notification.mCategory = json.getInt("mCategory")
        notification.mTime = json.getLong("mTime")
        notification.mPackage = json.getString("mPackage")
        notification.mTitle = json.getString("mTitle")
        notification.mContent = json.getString("mContent")
        return notification
    }
}

object BleWeatherHelper {
    fun fromJson(json: JSONObject): BleWeather {
        val weather = BleWeather()
        weather.mCurrentTemperature = json.getInt("mCurrentTemperature")
        weather.mMaxTemperature = json.getInt("mMaxTemperature")
        weather.mMinTemperature = json.getInt("mMinTemperature")
        weather.mWeatherCode = json.getInt("mWeatherCode")
        weather.mWindSpeed = json.getInt("mWindSpeed")
        weather.mHumidity = json.getInt("mHumidity")
        weather.mVisibility = json.getInt("mVisibility")
        weather.mUltraVioletIntensity = json.getInt("mUltraVioletIntensity")
        weather.mPrecipitation = json.getInt("mPrecipitation")
        return weather
    }
}

object BleWeatherForecastHelper {
    fun fromJson(json: JSONObject): BleWeatherForecast {
        val weatherForecast = BleWeatherForecast(0, null, null, null)
        weatherForecast.mTime = json.getInt("mTime")
        weatherForecast.mWeather1 = BleWeatherHelper.fromJson(json.getJSONObject("mWeather1"))
        weatherForecast.mWeather2 = BleWeatherHelper.fromJson(json.getJSONObject("mWeather2"))
        weatherForecast.mWeather3 = BleWeatherHelper.fromJson(json.getJSONObject("mWeather3"))
        return weatherForecast
    }
}

object BleWeatherRealtimeHelper {
    fun fromJson(json: JSONObject): BleWeatherRealtime {
        val weatherRealtime = BleWeatherRealtime(0,null)
        weatherRealtime.mTime = json.getInt("mTime")
        weatherRealtime.mWeather = BleWeatherHelper.fromJson(json.getJSONObject("mWeather"))
        return weatherRealtime
    }
}

object BleScheduleHelper {
    fun fromJson(json: JSONObject): BleSchedule {
        val schedule = BleSchedule()
        schedule.mId = json.getInt("mId")
        schedule.mYear = json.getInt("mYear")
        schedule.mMonth = json.getInt("mMonth")
        schedule.mDay = json.getInt("mDay")
        schedule.mHour = json.getInt("mHour")
        schedule.mMinute = json.getInt("mMinute")
        schedule.mAdvance = json.getInt("mAdvance")
        schedule.mContent = json.getString("mContent")
        return schedule
    }
}

object BleLoveTapUserHelper {

    fun fromJson(json: JSONObject): BleLoveTapUser {
        val loveTapUser = BleLoveTapUser()
        loveTapUser.mId = json.getInt("mId")
        loveTapUser.mName = json.getString("mName")
        return loveTapUser
    }

    fun toJson(obj: BleLoveTapUser): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mId"] = obj.mId
        data["mName"] = obj.mName
        return data
    }

    fun listToJson(datas: List<BleLoveTapUser>): List<Map<String, Any>> {
        val list = mutableListOf<Map<String, Any>>()
        datas.forEach {
            list.add(toJson(it))
        }
        return list
    }
}

object BleHmTimeHelper {
    fun toJson(obj: BleHmTime): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mHour"] = obj.mHour
        data["mMinute"] = obj.mMinute
        return data
    }

    fun fromJson(json: JSONObject): BleHmTime {
        val hmTime = BleHmTime()
        hmTime.mHour = json.getInt("mHour")
        hmTime.mMinute = json.getInt("mMinute")
        return hmTime
    }
}

object BleMedicationReminderHelper {

    fun fromJson(json: JSONObject): BleMedicationReminder {
        val medicationReminder = BleMedicationReminder()
        medicationReminder.mId = json.getInt("mId")
        medicationReminder.mType = json.getInt("mType")
        medicationReminder.mUnit = json.getInt("mUnit")
        medicationReminder.mDosage = json.getInt("mDosage")
        medicationReminder.mRepeat = json.getInt("mRepeat")
        medicationReminder.mRemindTimes = json.getInt("mRemindTimes")
        medicationReminder.mRemindTime1 = BleHmTimeHelper.fromJson(json.getJSONObject("mRemindTime1"))
        medicationReminder.mRemindTime2 = BleHmTimeHelper.fromJson(json.getJSONObject("mRemindTime2"))
        medicationReminder.mRemindTime3 = BleHmTimeHelper.fromJson(json.getJSONObject("mRemindTime3"))
        medicationReminder.mRemindTime4 = BleHmTimeHelper.fromJson(json.getJSONObject("mRemindTime4"))
        medicationReminder.mRemindTime5 = BleHmTimeHelper.fromJson(json.getJSONObject("mRemindTime5"))
        medicationReminder.mRemindTime6 = BleHmTimeHelper.fromJson(json.getJSONObject("mRemindTime6"))
        medicationReminder.mStartYear = json.getInt("mStartYear")
        medicationReminder.mStartMonth = json.getInt("mStartMonth")
        medicationReminder.mStartDay = json.getInt("mStartDay")
        medicationReminder.mEndYear = json.getInt("mEndYear")
        medicationReminder.mEndMonth = json.getInt("mEndMonth")
        medicationReminder.mEndDay = json.getInt("mEndDay")
        medicationReminder.mName = json.getString("mName")
        medicationReminder.mLabel = json.getString("mLabel")
        return medicationReminder
    }

    fun toJson(obj: BleMedicationReminder): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mId"] = obj.mId
        data["mType"] = obj.mType
        data["mUnit"] = obj.mUnit
        data["mDosage"] = obj.mDosage
        data["mRepeat"] = obj.mRepeat
        data["mRemindTimes"] = obj.mRemindTimes
        data["mRemindTime1"] = BleHmTimeHelper.toJson(obj.mRemindTime1)
        data["mRemindTime2"] = BleHmTimeHelper.toJson(obj.mRemindTime2)
        data["mRemindTime3"] = BleHmTimeHelper.toJson(obj.mRemindTime3)
        data["mRemindTime4"] = BleHmTimeHelper.toJson(obj.mRemindTime4)
        data["mRemindTime5"] = BleHmTimeHelper.toJson(obj.mRemindTime5)
        data["mRemindTime6"] = BleHmTimeHelper.toJson(obj.mRemindTime6)
        data["mStartYear"] = obj.mStartYear
        data["mStartMonth"] = obj.mStartMonth
        data["mStartDay"] = obj.mStartDay
        data["mEndYear"] = obj.mEndYear
        data["mEndMonth"] = obj.mEndMonth
        data["mEndDay"] = obj.mEndDay
        data["mName"] = obj.mName
        data["mLabel"] = obj.mLabel
        return data
    }

    fun listToJson(datas: List<BleMedicationReminder>): List<Map<String, Any>> {
        val list = mutableListOf<Map<String, Any>>()
        datas.forEach {
            list.add(toJson(it))
        }
        return list
    }
}

object BleLoveTapHelper {
    fun toJson(obj: BleLoveTap): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mTime"] = obj.mTime
        data["mId"] = obj.mId
        data["mActionType"] = obj.mActionType
        return data
    }

    fun fromJson(json: JSONObject): BleLoveTap {
        val loveTap = BleLoveTap()
        loveTap.mTime = json.getLong("mTime")
        loveTap.mId = json.getInt("mId")
        loveTap.mActionType = json.getInt("mActionType")
        return loveTap
    }
}

object BleNewsFeedHelper {
    fun fromJson(json: JSONObject): BleNewsFeed {
        val newsFeed = BleNewsFeed()
        newsFeed.mCategory = json.getInt("mCategory")
        newsFeed.mUid = json.getInt("mUid")
        newsFeed.mTime = json.getLong("mTime")
        newsFeed.mTitle = json.getString("mTitle")
        newsFeed.mContent = json.getString("mContent")
        return newsFeed
    }
}

object BleDeviceInfo2Helper {
    fun toJson(deviceInfo: BleDeviceInfo2): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mBleName"] = deviceInfo.mBleName
        data["mBleAddress"] = deviceInfo.mBleAddress
        data["mClassicAddress"] = deviceInfo.mClassicAddress
        data["mFirmwareVersion"] = deviceInfo.mFirmwareVersion
        data["mUiVersion"] = deviceInfo.mUiVersion
        data["mLanguageVersion"] = deviceInfo.mLanguageVersion
        data["mLanguageCode"] = deviceInfo.mLanguageCode
        data["mPlatform"] = deviceInfo.mPlatform
        data["mPrototype"] = deviceInfo.mPrototype
        data["mFirmwareFlag"] = deviceInfo.mFirmwareFlag
        data["mFullVersion"] = deviceInfo.mFullVersion
        return data
    }
}

object BleHrWarningSettingsHelper {
    fun toJson(obj: BleHrWarningSettings): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mHighSwitch"] = obj.mHighSwitch
        data["mHighValue"] = obj.mHighValue
        data["mLowSwitch"] = obj.mLowSwitch
        data["mLowValue"] = obj.mLowValue
        return data
    }

    fun fromJson(json: JSONObject): BleHrWarningSettings {
        val hrWarningSettings = BleHrWarningSettings()
        hrWarningSettings.mHighSwitch = json.getInt("mHighSwitch")
        hrWarningSettings.mHighValue = json.getInt("mHighValue")
        hrWarningSettings.mLowSwitch = json.getInt("mLowSwitch")
        hrWarningSettings.mLowValue = json.getInt("mLowValue")
        return hrWarningSettings
    }
}

object BleSleepMonitoringSettingsHelper {
    fun toJson(obj: BleSleepMonitoringSettings): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mEnabled"] = obj.mEnabled
        data["mStartHour"] = obj.mStartHour
        data["mStartMinute"] = obj.mStartMinute
        data["mEndHour"] = obj.mEndHour
        data["mEndMinute"] = obj.mEndMinute
        return data
    }

    fun fromJson(json: JSONObject): BleSleepMonitoringSettings {
        val sleepMonitoringSettings = BleSleepMonitoringSettings()
        sleepMonitoringSettings.mEnabled = json.getInt("mEnabled")
        sleepMonitoringSettings.mStartHour = json.getInt("mStartHour")
        sleepMonitoringSettings.mStartMinute = json.getInt("mStartMinute")
        sleepMonitoringSettings.mEndHour = json.getInt("mEndHour")
        sleepMonitoringSettings.mEndMinute = json.getInt("mEndMinute")
        return sleepMonitoringSettings
    }
}

object BleWeather2Helper {
    fun fromJson(json: JSONObject): BleWeather2 {
        val weather = BleWeather2()
        weather.mCurrentTemperature = json.getInt("mCurrentTemperature")
        weather.mMaxTemperature = json.getInt("mMaxTemperature")
        weather.mMinTemperature = json.getInt("mMinTemperature")
        weather.mWeatherCode = json.getInt("mWeatherCode")
        weather.mWindSpeed = json.getInt("mWindSpeed")
        weather.mHumidity = json.getInt("mHumidity")
        weather.mVisibility = json.getInt("mVisibility")
        weather.mUltraVioletIntensity = json.getInt("mUltraVioletIntensity")
        weather.mPrecipitation = json.getInt("mPrecipitation")
        weather.mSunriseHour = json.getInt("mSunriseHour")
        weather.mSunrisMinute = json.getInt("mSunrisMinute")
        weather.mSunrisSecond = json.getInt("mSunrisSecond")
        weather.mSunsetHour = json.getInt("mSunsetHour")
        weather.mSunsetMinute = json.getInt("mSunsetMinute")
        weather.mSunsetSecond = json.getInt("mSunsetSecond")
        return weather
    }
}

object BleWeatherForecast2Helper {
    fun fromJson(json: JSONObject): BleWeatherForecast2 {
        val weatherForecast = BleWeatherForecast2(0, "", null, null, null, null, null, null, null)
        weatherForecast.mTime = json.getInt("mTime")
        weatherForecast.mCityName = json.getString("mCityName")
        weatherForecast.mWeather1 = BleWeather2Helper.fromJson(json.getJSONObject("mWeather1"))
        weatherForecast.mWeather2 = BleWeather2Helper.fromJson(json.getJSONObject("mWeather2"))
        weatherForecast.mWeather3 = BleWeather2Helper.fromJson(json.getJSONObject("mWeather3"))
        weatherForecast.mWeather4 = BleWeather2Helper.fromJson(json.getJSONObject("mWeather4"))
        weatherForecast.mWeather5 = BleWeather2Helper.fromJson(json.getJSONObject("mWeather5"))
        weatherForecast.mWeather6 = BleWeather2Helper.fromJson(json.getJSONObject("mWeather6"))
        weatherForecast.mWeather7 = BleWeather2Helper.fromJson(json.getJSONObject("mWeather7"))
        return weatherForecast
    }
}

object BleWeatherRealtime2Helper {
    fun fromJson(json: JSONObject): BleWeatherRealtime2 {
        val weatherRealtime = BleWeatherRealtime2(0,"", null)
        weatherRealtime.mTime = json.getInt("mTime")
        weatherRealtime.mCityName = json.getString("mCityName")
        weatherRealtime.mWeather = BleWeather2Helper.fromJson(json.getJSONObject("mWeather"))
        return weatherRealtime
    }
}

object BleDrinkWaterSettingsHelper {
    fun fromJson(json: JSONObject): BleDrinkWaterSettings {
        val drinkWaterSettings = BleDrinkWaterSettings()
        drinkWaterSettings.mEnabled = json.getInt("mEnabled")
        drinkWaterSettings.mRepeat = json.getInt("mRepeat")
        drinkWaterSettings.mStartHour = json.getInt("mStartHour")
        drinkWaterSettings.mStartMinute = json.getInt("mStartMinute")
        drinkWaterSettings.mEndHour = json.getInt("mEndHour")
        drinkWaterSettings.mEndMinute = json.getInt("mEndMinute")
        drinkWaterSettings.mInterval = json.getInt("mInterval")
        return drinkWaterSettings
    }

    fun toJson(obj: BleDrinkWaterSettings): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mEnabled"] = obj.mEnabled
        data["mRepeat"] = obj.mRepeat
        data["mStartHour"] = obj.mStartHour
        data["mStartMinute"] = obj.mStartMinute
        data["mEndHour"] = obj.mEndHour
        data["mEndMinute"] = obj.mEndMinute
        data["mInterval"] = obj.mInterval
        return data
    }
}

object BleHrMonitoringSettingsHelper {
    fun fromJson(json: JSONObject): BleHrMonitoringSettings {
        val hrMonitoringSettings = BleHrMonitoringSettings()
        hrMonitoringSettings.mInterval = json.getInt("mInterval")
        hrMonitoringSettings.mBleTimeRange = BleTimeRangeHelper.fromJson(json.getJSONObject("mBleTimeRange"))
        return hrMonitoringSettings
    }

    fun toJson(obj: BleHrMonitoringSettings): Map<String, Any> {
        val data = HashMap<String, Any>()
        data["mInterval"] = obj.mInterval
        data["mBleTimeRange"] = BleTimeRangeHelper.toJson(obj.mBleTimeRange)
        return data
    }
}