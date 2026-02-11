#!/bin/bash
# KISA2026 main script by K

if [[ ! -n "$EUID" || "$EUID" -ne 0 ]]; then echo "관리자 권한으로 실행해주세요."; fi

echo "*** [KISA] 2026 정보통신기술기반시설 취약점 분석 및 평가 스크립트"
echo "*** 1) 분석 및 평가 모두 진행"
echo "*** 2) 중요도[상] - 42항목"
echo "*** 3) 중요도[중] - 16항목"
echo "*** 4) 중요도[하] - 9항목"
echo "*** 5) 종료"
echo "*** 평가 항목은 총 '67항목'으로 구성되어 있습니다."

while true; do
	read -p "*** 메뉴를 선택해주세요: " choice
	case $choice in
		1)
			Threat_High
			Threat_Medium
			Threat_Low
			;;
		2)
			Threat_High
			;;
		3)
			Threat_Low
			;;
		4)
			Threat_Low
			;;
		5)
			echo "평가 스크립트를 종료합니다."
			break
			;;
		*)
			echo "잘못 입력하셨습니다."
			;;
		
	esac
done

exit 0