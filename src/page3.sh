#!/bin/sh
#
# Page 3, thalamus
#
# Several coronal slices in series to get overview.
# Add a coronal slice at center of mass of LGN for thalamus segmentation. 
#
# Also take a look at LGN-centered axial cut.
#
# Include a plain T1 next to e.g. the axial thalamus for comparison.

# Working directory
TMP="${SUBJECTS_DIR}"/"${SUBJECT}"/tmp

# mri directory
MRI="${SUBJECTS_DIR}"/"${SUBJECT}"/mri



# Get LGN location: left is 8109, right is 8209
# /usr/local/freesurfer/FreeSurferColorLUT.txt
RASL=`/usr/local/fsl/bin/fslstats \
${SUBJECTS_DIR}/NII_THALAMUS/ThalamicNuclei.v10.T1.FSvoxelSpace.nii.gz \
-l 8108.5 -u 8109.5 -c`
RL=`echo "${RASL}" | awk '{printf "%d",$1}'`
AL=`echo "${RASL}" | awk '{printf "%d",$2}'`
SL=`echo "${RASL}" | awk '{printf "%d",$3}'`

RASR=`/usr/local/fsl/bin/fslstats \
${SUBJECTS_DIR}/NII_THALAMUS/ThalamicNuclei.v10.T1.FSvoxelSpace.nii.gz \
-l 8208.5 -u 8209.5 -c`
RR=`echo "${RASR}" | awk '{printf "%d",$1}'`
AR=`echo "${RASR}" | awk '{printf "%d",$2}'`
SR=`echo "${RASR}" | awk '{printf "%d",$3}'`

LGNR=`echo "(${RL} + ${RR}) / 2" | bc`
LGNA=`echo "(${AL} + ${AR}) / 2" | bc`
LGNS=`echo "(${SL} + ${SR}) / 2" | bc`

# Get RAS mm coords of region centroid, averaging over two regions
# https://surfer.nmr.mgh.harvard.edu/fswiki/CoordinateSystems
#    10   L thalamus
#    49   R thalamus
RASL=`/usr/local/fsl/bin/fslstats ${SUBJECTS_DIR}/NII_ASEG/aseg.nii.gz -l 9.5 -u 10.5 -c`
RL=`echo "${RASL}" | awk '{printf "%d",$1}'`
AL=`echo "${RASL}" | awk '{printf "%d",$2}'`
SL=`echo "${RASL}" | awk '{printf "%d",$3}'`

RASR=`/usr/local/fsl/bin/fslstats ${SUBJECTS_DIR}/NII_ASEG/aseg.nii.gz -l 48.5 -u 49.5 -c`
RR=`echo "${RASR}" | awk '{printf "%d",$1}'`
AR=`echo "${RASR}" | awk '{printf "%d",$2}'`
SR=`echo "${RASR}" | awk '{printf "%d",$3}'`

THALR=`echo "(${RL} + ${RR}) / 2" | bc`
THALA=`echo "(${AL} + ${AR}) / 2" | bc`
THALS=`echo "(${SL} + ${SR}) / 2" | bc`



# Freeview command line chunks
V_STR="-viewsize 400 350 --layout 1 --zoom 4"
T1_STR="-v ${MRI}/T1.mgz"
SEG_STR="-v ${MRI}/ThalamicNuclei.v10.T1.FSvoxelSpace.mgz:visible=1:colormap=lut"

# Coronal slices, A to P
freeview --viewport coronal ${V_STR} ${T1_STR} \
	-ras "${THALR}" "$((THALA+14))" "${THALS}" \
    -ss "${TMP}"/cor_a14_plain.png
freeview --viewport coronal ${V_STR} ${T1_STR} ${SEG_STR} \
	-ras "${THALR}" "$((THALA+14))" "${THALS}" \
    -ss "${TMP}"/cor_a14.png

freeview --viewport coronal ${V_STR} ${T1_STR} \
	-ras "${THALR}" "$((THALA+7))" "${THALS}" \
    -ss "${TMP}"/cor_a7_plain.png
freeview --viewport coronal ${V_STR} ${T1_STR} ${SEG_STR} \
	-ras "${THALR}" "$((THALA+7))" "${THALS}" \
    -ss "${TMP}"/cor_a7.png

freeview --viewport coronal ${V_STR} ${T1_STR} \
	-ras "${THALR}" "${THALA}" "${THALS}" \
    -ss "${TMP}"/cor_0_plain.png
freeview --viewport coronal ${V_STR} ${T1_STR} ${SEG_STR} \
	-ras "${THALR}" "${THALA}" "${THALS}" \
    -ss "${TMP}"/cor_0.png

freeview --viewport coronal ${V_STR} ${T1_STR} \
	-ras "${THALR}" "$((THALA-7))" "${THALS}" \
    -ss "${TMP}"/cor_p7_plain.png
freeview --viewport coronal ${V_STR} ${T1_STR} ${SEG_STR} \
	-ras "${THALR}" "$((THALA-7))" "${THALS}" \
    -ss "${TMP}"/cor_p7.png

freeview --viewport coronal ${V_STR} ${T1_STR} \
	-ras "${THALR}" "${LGNA}" "${THALS}" \
    -ss "${TMP}"/cor_lgn_plain.png
freeview --viewport coronal ${V_STR} ${T1_STR} ${SEG_STR} \
	-ras "${THALR}" "${LGNA}" "${THALS}" \
    -ss "${TMP}"/cor_lgn.png

# Axial slices
freeview --viewport axial ${V_STR} ${T1_STR} \
	-ras "${THALR}" "${THALA}" "${LGNS}" \
    -ss "${TMP}"/axi_lgn_plain.png
freeview --viewport axial ${V_STR} ${T1_STR} ${SEG_STR} \
	-ras "${THALR}" "${THALA}" "${LGNS}" \
    -ss "${TMP}"/axi_lgn.png

freeview --viewport axial ${V_STR} ${T1_STR} \
	-ras "${THALR}" "${THALA}" "${THALS}" \
    -ss "${TMP}"/axi_0_plain.png
freeview --viewport axial ${V_STR} ${T1_STR} ${SEG_STR} \
	-ras "${THALR}" "${THALA}" "${THALS}" \
    -ss "${TMP}"/axi_0.png

freeview --viewport axial ${V_STR} ${T1_STR} \
	-ras "${THALR}" "${THALA}" "$((THALS+7))" \
    -ss "${TMP}"/axi_s7_plain.png
freeview --viewport axial ${V_STR} ${T1_STR} ${SEG_STR} \
	-ras "${THALR}" "${THALA}" "$((THALS+7))" \
    -ss "${TMP}"/axi_s7.png

# Sagittal
freeview --viewport sagittal ${V_STR} ${T1_STR} \
	-ras "${RL}" "${AL}" "${SL}" \
	-ss "${TMP}"/sag_L_plain.png
freeview --viewport sagittal ${V_STR} ${T1_STR} ${SEG_STR} \
	-ras "${RL}" "${AL}" "${SL}" \
	-ss "${TMP}"/sag_L.png

freeview --viewport sagittal ${V_STR} ${T1_STR} \
	-ras "${RR}" "${AR}" "${SR}" \
	-ss "${TMP}"/sag_R_plain.png
freeview --viewport sagittal ${V_STR} ${T1_STR} ${SEG_STR} \
	-ras "${RR}" "${AR}" "${SR}" \
	-ss "${TMP}"/sag_R.png



# Layout. 20 panels, 4 wide (2 pairs) by 5 high.
cd "${TMP}"
montage -mode concatenate \
cor_lgn_plain.png cor_lgn.png cor_p7_plain.png cor_p7.png \
cor_0_plain.png cor_0.png cor_a7_plain.png cor_a7.png \
cor_a14_plain.png cor_a14.png sag_L_plain.png sag_L.png \
sag_R_plain.png sag_R.png axi_s7_plain.png axi_s7.png \
axi_0_plain.png axi_0.png axi_lgn_plain.png axi_lgn.png \
-tile 4x5 -quality 100 -background white -gravity center \
-trim -border 5 -bordercolor white -resize 600x twenty.png

# Add info
# 8.5 x 11 at 144dpi is 1224 x 1584
# inside 15px border is 1194 x 1554
convert \
-size 1224x1584 xc:white \
-gravity center \( twenty.png -resize 1194x1554 \) -geometry +0+80 -composite \
-gravity NorthEast -pointsize 24 -annotate +15+10 "Thalamus" \
-gravity SouthEast -pointsize 24 -annotate +15+10 "$(date)" \
-gravity SouthWest -annotate +15+10 "`cat $FREESURFER_HOME/build-info.txt`" \
-gravity NorthWest -pointsize 24 -annotate +15+10 "${SUBJECT}" \
page3.png
