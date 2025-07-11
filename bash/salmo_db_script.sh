# restore salmo db to localhost
D:
cd diaspara/salmoglob
createDB -U postgres salmoglob
psql -U postgres -h 185.135.126.250 -f salmoglob_04_04_2025.backup salmoglob
# there should be a salmoglob_admin and a role atlas
psql -U postgres -c "CREATE role salmoglob_admin with password '****'";
psql -U postgres -c "CREATE role atlas with password '****'";

# there is now a role salmoglob on the server