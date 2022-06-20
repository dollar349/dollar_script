#!/bin/sh
ABSPATH=$(readlink -f "$BASH_SOURCE")
SCRIPTPATH=$(dirname "$ABSPATH")
# Check _GET_PROJECT_INFO.sh script exist
if test ! -f ${SCRIPTPATH}/_GET_PROJECT_INFO.sh; then
    echo "_GET_PROJECT_INFO.sh not found"
    exit 1
fi
source ${SCRIPTPATH}/_GET_PROJECT_INFO.sh
if test "${PRJ_INFO}" != "OK" ; then
    echo "Project path not found"
    exit 1
fi

RELEASE_FOLDER=`pwd`/`date +%Y_%m_%d`_ReleaseFor_${PRJ_MACHINE}

cd ${PRJ_BUILD_PATH} && \
TAG_NAME=`git rev-parse --abbrev-ref HEAD | awk -F'/' '{print $NF}'` && \
cd -

print_help()
{
    echo ""
    echo "This script helps to Get release file for Cobra project"
    echo "  Usage: $(basename $0) [options] ..."
    echo "  option: "
    echo "    -o [output floder]"
    echo "        Specify an output folder"
    echo "    -t [tag name]"
    echo "        Using branch name as default. You can specify another git tag name"
}

while getopts 'o:t:h' OPT; do
    case $OPT in
        t)  
            TAG_NAME=$OPTARG
            ;;
        o)  
            RELEASE_FOLDER=$OPTARG
            ;;
        h)
            print_help
            exit 0
            ;;
        ?)
            print_help
            exit 1
            ;;
    esac
done

if test "${TAG_NAME}" = "";then
    echo "Please give a tag name"
    exit 1
fi

case ${PRJ_MACHINE} in
	"cobra-zynqmp")
	IMAGE_NAME=zynqmp-image-${TAG_NAME}
    FWU_IMAGE_NAME=ipuhd_${TAG_NAME}.static.mtd.tar
    LICENSE_FILE=foss-IPUHD-${TAG_NAME}-license.manifest
 ;;
	"cobra-ast2600evb")
    FWU_IMAGE_NAME=ipfhd_${TAG_NAME}.static.mtd.tar
 ;;
 	"ipsl-ast2600")
	IMAGE_NAME=ipsl-ast2600-image-${TAG_NAME}
    FWU_IMAGE_NAME=ipsl_${TAG_NAME}.static.mtd.tar
    LICENSE_FILE=foss-IPSL-${TAG_NAME}-license.manifest
 ;;
    *)
    echo "PRJ_MACHINE = ${PRJ_MACHINE} not supported"
    exit 1
esac

if [ ! -d "${RELEASE_FOLDER}" ]; then
  # script statements if $RELEASE_FOLDER doesn't exist.
  mkdir -p ${RELEASE_FOLDER}
fi

###################################################
#   Copy image-xxx file to a tar-ball             #
#                                                 #
###################################################
if test "${IMAGE_NAME}" != ""; then
   rm -rf ${RELEASE_FOLDER}/${IMAGE_NAME}.tar.gz
   rm -rf ${RELEASE_FOLDER}/${IMAGE_NAME}
   mkdir ${RELEASE_FOLDER}/${IMAGE_NAME}
   cp ${PRJ_DEPLOY_IMAGE_PATH}/image-* ${RELEASE_FOLDER}/${IMAGE_NAME}/.
   rm ${RELEASE_FOLDER}/${IMAGE_NAME}/image-rwfs
   cd ${RELEASE_FOLDER} && \
   tar czvf ${IMAGE_NAME}.tar.gz ${IMAGE_NAME} && \
   cd -
fi

###################################################
#          Copy Firmware update file              #
#                                                 #
###################################################
if test "${FWU_IMAGE_NAME}" != ""; then
   rm -rf ${RELEASE_FOLDER}/${FWU_IMAGE_NAME}
   cp ${PRJ_IMAGE} ${RELEASE_FOLDER}/${FWU_IMAGE_NAME}
fi


###################################################
#              Copy License file                  #
#                                                 #
###################################################
if test "${LICENSE_FILE}" != ""; then
   rm -rf ${RELEASE_FOLDER}/${LICENSE_FILE}
   cp ${PRJ_BUILD_PATH}/tmp/deploy/licenses/obmc-phosphor-image-${PRJ_MACHINE}/license.manifest ${RELEASE_FOLDER}/${LICENSE_FILE} && \
   cat ${PRJ_BUILD_PATH}/tmp/deploy/licenses/obmc-phosphor-image-${PRJ_MACHINE}/image_license.manifest >> ${RELEASE_FOLDER}/${LICENSE_FILE}
fi