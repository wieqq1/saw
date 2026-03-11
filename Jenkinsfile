pipeline {
    agent any // Запускает пайплайн на любом доступном агенте

    environment {
        // Имя вашего образа в Docker Hub
        DOCKER_IMAGE = 'wieq1/my-laravel-app'
        // Используем учетные данные, которые мы добавили ранее
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
    }

    stages {
        stage('Checkout') {
            steps {
                // Получаем код из репозитория
                git branch: 'main', url: 'https://github.com/wieqq1/saw.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Собираем Docker-образ
                    dockerImage = docker.build("${env.DOCKER_IMAGE}:${env.BUILD_ID}")
                }
            }
        }

        // stage('Run Tests') {
        //     steps {
        //         script {
        //             // Запускаем контейнер для выполнения тестов (например, PHPUnit)
        //             // '--rm' удалит контейнер после выполнения команды
        //             dockerImage.inside("--rm") {
        //                 sh 'composer install --no-dev --optimize-autoloader'
        //                 sh 'php artisan test --env=testing'
        //             }
        //         }
        //     }
        // }

        stage('Push Docker Image') {
            steps {
                script {
                    // Логинимся в Docker Hub используя учётные данные из Jenkins
                    docker.withRegistry('https://index.docker.io/v1/', "${env.DOCKER_CREDENTIALS_ID}") {
                        // Пушим образ с тегом BUILD_ID
                        dockerImage.push("${env.BUILD_ID}")
                        // Также пушим образ с тегом 'latest'
                        dockerImage.push('latest')
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Шаг развертывания (пример для простого сценария на этой же машине)
                    // 1. Останавливаем старый контейнер
                    sh 'docker stop my-running-app || true'
                    sh 'docker rm my-running-app || true'
                    // 2. Запускаем новый контейнер из только что собранного образа
                    sh "docker run -d -p 8082:80 --name my-running-app ${env.DOCKER_IMAGE}:${env.BUILD_ID}"
                }
            }
        }
    }

    post {
        always {
            // Очистка: удаляем все dangling images
            sh 'docker image prune -f'
        }
        failure {
            // Можно добавить уведомление об ошибке (email, Slack и т.д.)
            echo 'Pipeline failed!'
        }
        success {
            echo 'Pipeline succeeded!'
        }
    }
}
