component restpath="user" {
    remote function register() httpMethod="POST" restargsource="form" {
        param name="email" type="string" required=true;
        param name="password" type="string" required=true;
        param name="firstName" type="string" required=true;
        param name="lastName" type="string" required=true;
        param name="role" type="string" required=true;
        
        return createObject("component", "handlers.UserHandler").registerUser(
            email, password, firstName, lastName, role
        );
    }

    remote function getUser() httpMethod="GET" restargsource="url" {
        param name="email" type="string" required=true;

        return createObject("component", "handlers.UserHandler").getUserByEmail(email);
    }
}
