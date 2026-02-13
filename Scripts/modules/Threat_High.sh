#!/bin/bash
# KISA2026 high threat script by K
# target OS: LINUX - RedHat
# contributor: Microsoft Copilot, Google Gemini
#		details: vim editing, locate vs find, helper (_) 관례, case 제안, 로직 제안 등과 intuition 정리

# 관리자 권한 검사
if [[ "$EUID" != 0 ]]; then echo ">>> [오류] 관리자 권한으로 실행해주세요."; exit 0; fi

# ㄱ. 탐색
# 1. 파일의 경로 탐색 1차
# 2. 파일의 경로 탐색 2차
# 3. 파일의 설정 여부
# ㄴ. 보고
# 1. 시작 보고
# 2. 중간 보고
# 3. 결과 보고
# ㄷ. 기록
# 1. 보고 출력 기록화
# 2. 최종 형태로 출력
# ㄹ. 예외 처리
# 1. 실행시 권한 인증
# 2. 파일 없으면 감점

_logger() {
	case "$1" in
		config_yes)
			echo ">>> $2 설정 내용이 존재합니다."
			;;
		config_no)
			echo ">>> $2 설정 내용이 존재하지 않습니다."
			;;
		error_occured)
			echo ">>> $2 오류가 발생했습니다."
			;;
		file_exist)
			echo ">>> $2 설정 또는 파일이 존재합니다."
			;;
		file_search)
			echo ">>> $2 설정 또는 파일을 찾는중입니다."
			;;
		file_not_found)
			echo ">>> [경고] $2 파일을 찾을 수 없습니다."
			;;
		file_scan_deep)
			echo ">>> [경고] $2 파일이 기본 경로에 존재하지 않습니다. 정밀 탐색을 실시합니다."
			;;
		result_bad)
			printf ">>> [판정] %s 기준 부적합\n\n" "$2"
			;;
		result_good)
			printf ">>> [판정] %s 기준 양호\n\n" "$2"
			;;
		*)
			echo "*** $2 [상] 평가를 실시합니다."
			;;
	esac
}

_scanner() {		# 파일 탐색
	# TODO: 파일이 발견되지 않거나 하면 file 변수는...?
	# TODO: 탐색이 기록과 따로 존재하며 함께 작동하려면...?

	rpm -qi mlocate &> /dev/null
	if [[ $? -eq 0 ]]; then		
		update_db
		locate -q "$file" &> /dev/null
	fi
}

_scanner_deep() {	# 파일 정밀 탐색
	find "$basedir" -type f -name "$basefile"
	find '/' -type d -name "$basedir" -exec grep -Rix "$basefile" {} \; &> /dev/null
}

_inspector() {	# 설정 검사
	grep -qE "$config" "$file"
	grep -qix "$config" "$file"
}

_repeater() {	# 다중 처리
    shift							# shell만 가진 것

    while [[ $# -gt 0 ]]; do		# 반복 구조 처리
		_scanner "$object_code" "$1" "$2" "$3"
		shift 3
	done
}

_variables() {	# 변수 저장
	local object_code="$1"
	local basedir="$2"
	local basefile="$3"
	local config="$4"

	local file="$basedir/$basefile"
}



main() {
	# TODO: repeater 삽입

	_variables				# 준비
	echo "검사 시작"		# 실시 안내
	_scanner				# 탐색 1차
	if [[ $? -ne 0 ]]; then
		_scanner_deep		# 탐색 2차
	fi
	_inspector				# 검사
	_report					# 보고

	exit 0
}

# 독립 구조로 관리
# '상'으로 분류된 기준

# U-01() {
# 	# caseA
# 	local caseA_dir1="/etc/pam.d"
# 	local caseA_file1="login"
# 
# 	# caseB
# 	local caseB_dir1="/etc/ssh"
# 	local caseB_file1="sshd_config"
# 
# 	# execute
# 	_repeater "U-01" \
# 	"$caseA_dir1" "$caseA_file1" "auth required /lib/security/pam_securetty.so" \
# 	"$caseB_dir1" "$caseB_file1" "PermitRootLogin no"
# }
# 
# U-02() {
# 	# caseA
# 	local caseA_dir1="/etc"
# 	local caseA_file1="login.defs"	
# 
# 	# caseB
# 	local caseB_dir1="/etc/security"
# 	local caseB_file1="pwquality.conf"
# 	local caseB_file2="pwhistory.conf"
# 
# 	# caseC
# 	local caseC_dir1="/etc/pam.d"
# 	local caseC_file1="system-auth"
# 
# 	# execute
# 	_repeater "U-02" \
# 	"$caseA_dir1" "$caseA_file1" "PASS_MAX_DAYS 90" \
# 	"$caseA_dir1" "$caseA_file1" "PASS_MIN_DAYS 0" \
# 	"$caseB_dir1" "$caseB_file1" "minlen = 8" \
# 	"$caseB_dir1" "$caseB_file1" "dcredit = -1" \
# 	"$caseB_dir1" "$caseB_file1" "ucredit = -1" \
# 	"$caseB_dir1" "$caseB_file1" "lcredit = -1" \
# 	"$caseB_dir1" "$caseB_file1" "ocredit = -1" \
# 	"$caseB_dir1" "$caseB_file1" "enforce_for_root" \
# 	"$caseB_dir1" "$caseB_file2" "enforce_for_root" \
# 	"$caseB_dir1" "$caseB_file2" "remember=4" \
# 	"$caseB_dir1" "$caseB_file2" "file = /etc/security/opasswd" \
# 	"$caseC_dir1" "$caseC_file1" "enforce_for_root"			# TODO: 내용 수정 및 보완
# }
# 
# U-03() {
# 	_repeater "U-03" \
# 	"" "" "" 
# }




# 평가 수행
U-01
#U-02
