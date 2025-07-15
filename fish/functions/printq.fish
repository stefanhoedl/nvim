function printq
    smbclient -U "stefan.hoedl@ru.nl" //print.hosting.ru.nl/FollowMe -c "print \"$argv[1]\""
end
