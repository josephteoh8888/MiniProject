//
//  Constant.swift
//  MiniProject
//
//  Created by Joseph Teoh on 29/06/2024.
//

import Foundation

enum DataTypes {
    static let LOOP = "video"
    static let POST = "post"
    static let SHOT = "photo"
    static let USER = "u"
    static let LOCATION = "p"
    static let SOUND = "s"
}

//test > use enum to define constants for originator type
enum OriginatorTypes {
    static let MARKER = "OMarker"
    static let PLACEMARKER = "OPlaceMarker"
    static let PULSEWAVE = "OPulsewave"
    static let MAP_UIVIEW = "OMapUIView"
    static let MAP_TOP_UIVIEW = "OMapTopUIView"
    static let MAP_VIDEO_MINIAPP_UIVIEW = "OMapVideoMiniAppUIView"
    static let UIVIEW = "OUIView"
}

enum VideoCreatorFileTypes {
    static let DRAFT_VIDEO_FILES_FOLDER_NAME = "DdmAppDraft"
    static let DRAFT_VIDEO_FILE_OUTPUT_NAME = "draft_video_output.mp4"
    static let SPLIT_AUDIO_FILE_OUTPUT_NAME = "split_audio_output.m4a"
    static let DRAFT_GIF_FILE_OUTPUT_NAME = "draft_gif_output.gif"
    static let DRAFT_COVER_IMAGE_FILE_OUTPUT_NAME = "draft_cover_image_output.jpg"
    static let RECORDED_VIDEO_FILE_OUTPUT_NAME = "recorded_video_output.mp4"
    static let DRAFT_OVERLAY_VIDEO_FILE_OUTPUT_NAME = "draft_overlay_video_output.mp4"
    static let DRAFT_BLUROUT_VIDEO_FILE_OUTPUT_NAME = "draft_blurout_video_output.mp4"
}

//test > for geodata ...may delete later
enum GeoDataTypes {
    static let MARKER = "OMarker"
    static let PLACEMARKER = "OPlaceMarker"
    static let USERMARKER = "OUserMarker"
}

//test > marker id
enum OriginatorId {
    static let USER_LOCATION_MARKER_ID = "current_user_location_id"
}

//test > for video types
enum VideoTypes {
    static let V_LOOP = "VideoLoop"
    static let V_0 = "Video" //simple video
}

//test > for photo types
enum PhotoTypes {
    static let P_SHOT = "PhotoShot"
    static let P_SHOT_DETAIL = "PhotoShotDetail"
    static let P_0 = "Photo" //simple photo
}
