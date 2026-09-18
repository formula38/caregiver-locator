component {

    public any function init() {
        variables.users = new services.UserService();
        variables.auth = new lib.Auth();
        variables.response = new lib.Response();
        variables.validation = new lib.Validation();
        return this;
    }

    public struct function register(required struct requestContext) {
        var body = requestContext.body;
        var errors = variables.validation.requireFields(body, ["email", "password", "firstName", "lastName", "role"]);
        if (structKeyExists(body, "email")) {
            errors = variables.validation.merge(errors, variables.validation.emailFormat(body.email));
        }
        if (structKeyExists(body, "password")) {
            errors = variables.validation.merge(errors, variables.validation.minLength(body.password, 8, "password"));
        }
        if (structKeyExists(body, "role")) {
            errors = variables.validation.merge(errors, variables.validation.oneOf(body.role, ["recipient", "provider"], "role"));
        }
        if (arrayLen(errors)) {
            return variables.response.unprocessable(errors);
        }
        try {
            var user = variables.users.register(
                email = body.email,
                password = body.password,
                firstName = body.firstName,
                lastName = body.lastName,
                role = body.role
            );
            return variables.response.created({
                "user": user,
                "token": variables.auth.issue(user)
            });
        } catch (UserService.DuplicateEmail e) {
            return variables.response.conflict("Email already registered");
        }
    }

    public struct function login(required struct requestContext) {
        var body = requestContext.body;
        var errors = variables.validation.requireFields(body, ["email", "password"]);
        if (arrayLen(errors)) {
            return variables.response.unprocessable(errors);
        }
        var user = variables.users.authenticate(body.email, body.password);
        if (isNull(user)) {
            return variables.response.unauthorized("Invalid email or password");
        }
        return variables.response.ok({
            "user": user,
            "token": variables.auth.issue(user)
        });
    }

    public struct function me(required struct requestContext) {
        var user = variables.users.findById(requestContext.user.id);
        if (isNull(user)) {
            return variables.response.notFound("User not found");
        }
        return variables.response.ok({ "user": user });
    }

}
