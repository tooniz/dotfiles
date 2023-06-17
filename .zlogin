
for file in /etc/profile.d/*.sh; do
    emulate bash -c 'source "$file"'
done
