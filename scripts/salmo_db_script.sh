# restore salmo db to localhost
D:
cd diaspara/salmoglob
createDB -U postgres salmoglob
psql -U postgres -f salmoglob_diaspara.backup salmoglob
# there should be a salmoglob_admin and a role atlas
psql -U postgres -c "CREATE role salmoglob_admin with password 'salmoglob_admin'";
psql -U postgres -c "CREATE role atlas with password '****'";