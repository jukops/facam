# 할것
- terraform으로 워커 생성
- oidc provider
- nginx no label로 배포, pending 상태 확인 및 describe로 상세 설명 출력
- nginx label로 배포, 정상적으로 msa pod 배포 확인
- CA 배포
- 배포 여러번 해도 다른곳으로 이동 안하는것 확인.
- 진행할 taint, tolerations 구성 설명
- Terraform code 
- cluster autoscaler 설치
- foo 컨테이너 띄우기 및 test node 생성
- foo container CPU usage 높히고, test만 영향 받는것 보여주기. 격리를 위해 hpa와 limit 등 제공. 중요한건 실제 app 분리해 영향 안받게 하는것.
- tag 설명하고 주의점. 없으면 ASG에 태그 붙히기 --node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/facam-eks

# 순서
- EKS worker 생성
- 
