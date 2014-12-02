#!/bin/sh
set -e

echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"

install_framework()
{
  echo "rsync --exclude '*.h' -av ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
  rsync -av "${BUILT_PRODUCTS_DIR}/Pods/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
}

if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_framework 'AFNetworking.framework'
  install_framework 'ISO8601DateFormatterValueTransformer.framework'
  install_framework 'RKValueTransformers.framework'
  install_framework 'RestKit.framework'
  install_framework 'SOCKit.framework'
  install_framework 'SugarRecord.framework'
  install_framework 'TransitionKit.framework'
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_framework 'AFNetworking.framework'
  install_framework 'ISO8601DateFormatterValueTransformer.framework'
  install_framework 'RKValueTransformers.framework'
  install_framework 'RestKit.framework'
  install_framework 'SOCKit.framework'
  install_framework 'SugarRecord.framework'
  install_framework 'TransitionKit.framework'
fi
