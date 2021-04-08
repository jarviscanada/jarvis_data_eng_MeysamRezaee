sudo systemctl status docker || systemctl start docker

action=$1

case "$action" in
  
  create)
    if [docker container ls -a -f name=jrvs-psql | wc -l -eq 2] 
	then
	  echo 'error'
	  exit 1
	 fi
	
	
	if [$2 -eq 0] || [$3 -eq 0] 
	then
	  echo '2nd and 3rd arguments are not passed!'
	fi
	
	
	docker volume create pgdata
	docker run --name jrvs-psql -e POSTGRES_PASSWORD=${db_password} -e POSTGRES_USER=${db_username} -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres
	exit $?
	
	# if still not created
	if [docker container ls -a -f name=jrvs-psql | wc -l -ne 2] 
	then
	  echo 'still not created'
	  exit 1
	fi
  ;;

  start)
    docker start jrvs-psql
    exit $?
  ;;
    
  stop)
    docker stop jrvs-psql
    exit $?
  ;;
	
  *)
    echo 'invalid arguments!'
	exit 1
  ;;
	
esac
