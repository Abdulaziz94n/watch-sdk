package com.sma.sma_coding_dev_flutter_sdk

object OTAStatus {

    ///ota前有些预操作，如先扫描，再连接，连接成功才开始升级
    const val OTA_PREPARE = 1

    ///ota前准备工作失败
    const val OTA_PREPARE_FAILED = 2

    ///ota开始
    const val OTA_START = 3

    ///ota文件校验中, 杰里平台需要先校验文件后才开始升级
    const val OTA_CHECKING = 4

    ///ota升级中
    const val OTA_UPGRADEING = 5

    ///ota完成
    const val OTA_DONE = 6

    ///ota失败
    const val OTA_FAILED = 7

    ///未知
    const val UNKNOWN = -1
}