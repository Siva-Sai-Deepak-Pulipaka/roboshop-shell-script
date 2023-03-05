source common.sh

    #for both user and user steps are same so to follow code standards we are making it as NODEJS function in common.sh and just changing component names using a variable component.
component=user
schema_type="mongo" #here schema_type is a condition. if condition satisfies (if it is mongo) then only it will execute SCHEMA_SETUP.  SCHEMA_SETUP will be automatically called as we declared in common.sh 
NODEJS
