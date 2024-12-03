#!/bin/bash

# 목적지 디렉터리 설정
DEST_DIR="/home/ktw/Documents/GitHub/KiCAD_Libraries"

# 현재 경로에서 .tmp 디렉터리 생성 (존재하지 않으면)
TARGET_DIR="./.tmp"
if [ ! -d "$TARGET_DIR" ]; then
    mkdir "$TARGET_DIR"
    echo ".tmp 디렉터리를 생성했습니다."
fi

# 목적지 디렉터리 생성 (존재하지 않으면)
if [ ! -d "$DEST_DIR" ]; then
    mkdir "$DEST_DIR"
    echo "$DEST_DIR 디렉터리를 생성했습니다."
fi

# 현재 경로에서 LIB_로 시작하는 .zip 파일 검색
ZIP_FILES=($(find . -maxdepth 1 -type f -name "LIB_*.zip"))

# 처리할 파일이 없는 경우 종료
if [ ${#ZIP_FILES[@]} -eq 0 ]; then
    echo "LIB_로 시작하는 .zip 파일이 없습니다."
    exit 1
fi

# 각 ZIP 파일 처리
for ZIP_FILE in "${ZIP_FILES[@]}"; do
    echo "처리 중: $ZIP_FILE"

    # ZIP 파일을 .tmp 디렉터리에 압축 해제
    unzip -q "$ZIP_FILE" -d "$TARGET_DIR"
    if [ $? -eq 0 ]; then
        echo "$ZIP_FILE 압축 해제 완료"
    else
        echo "$ZIP_FILE 압축 해제 중 오류 발생"
        continue
    fi

    # PART 이름 추출
    PART=$(basename "$ZIP_FILE" | sed -e 's/^LIB_//' -e 's/\.zip$//')
    echo "PART: $PART"

    # .tmp/$PART/KiCad 안의 모든 파일을 DEST_DIR로 복사
    if [ -d "$TARGET_DIR/$PART/KiCad" ]; then
        cp -rf "$TARGET_DIR/$PART/KiCad/"* "$DEST_DIR/"
        echo "$PART의 파일이 $DEST_DIR로 복사되었습니다."
    else
        echo "$TARGET_DIR/$PART/KiCad 디렉터리가 없습니다. 건너뜁니다."
    fi

    # .tmp 디렉터리 정리
    rm -rf "$TARGET_DIR/$PART"
    rm -rf "$TARGET_DIR/"*
done
rm -rf "$TARGET_DIR"
# 최종적으로 .tmp 디렉터리 정리
echo ".tmp 디렉터리를 정리했습니다."
