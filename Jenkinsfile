node {
    checkout scm
	
	stage('git Progress') {
		git branch: 'main', credentialsId: 'my-git-credential', url: 'https://github.com/ggue/fakedemo-deploy.git'
	}

	stage('Build container image and Push') {
		// 기존 docker config가 존재하면 삭제해 주는거다
		// 가이드보고 진행함
		// 혹시라도 남아있을 config.json 파일 같은거 사전 삭제
		sh 'rm -f ~/.dockercfg ~/.docker/config.json || true' 

		// configure registry
		docker.withRegistry('https://179460961317.dkr.ecr.ap-northeast-2.amazonaws.com/fake-ecr', 'ecr:ap-northeast-2:my-aws-credential') {
		//build image
		// env.BUILD_ID는 자동으로 생김
		// default 변수
		def customImage = docker.build("179460961317.dkr.ecr.ap-northeast-2.amazonaws.com/fake-ecr:${env.BUILD_ID}")
		// push image
		customImage.push()
	}
	}

	stage('commit container tag to yaml') {
		// 이전에 있던것들이 좀꼬일수 있어서 문제가 될수있음
		sh 'rm -rf ./*'
		git branch: 'main', credentialsId: 'my-git-credential', url: 'https://github.com/ggue/kubernetes.git'
	
		// 디렉토리가 존재할때
	//	dir('') {
			def ecrRepo = "179460961317.dkr.ecr.ap-northeast-2.amazonaws.com\\/fake-ecr"
			sh "cat fake-ecr.yaml | sed -i \'s/${ecrRepo}:.*\$/${ecrRepo}:${env.BUILD_ID}/g\' fake-ecr.yaml"
	//	}

		withCredentials([usernamePassword(credentialsId: 'my-git-credential', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASSWORD')]) 
		{
			sh "git config --global credential.username $GIT_USER"
			sh "git config --global credential.helper '!f() { echo password=$GIT_PASSWORD; }; f'"
			sh 'git config --global user.email "jenkins@example.com"'
			sh 'git config --global user.name "jenkins"'
		
			sh "git add fake-ecr.yaml"
			sh "git commit -m 'change container image tag ${env.BUILD_ID}'"
			sh "git push 'https://github.com/ggue/kubernetes.git'"
		}
	}
}	