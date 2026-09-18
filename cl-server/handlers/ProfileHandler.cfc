component {

    public any function init() {
        variables.profiles = new services.ProfileService();
        variables.response = new lib.Response();
        return this;
    }

    public struct function showMine(required struct requestContext) {
        var profile = variables.profiles.findByUserId(requestContext.user.id);
        if (isNull(profile)) {
            return variables.response.notFound("Profile not found");
        }
        return variables.response.ok({ "profile": profile });
    }

    public struct function show(required struct requestContext) {
        var profile = variables.profiles.findByUserId(val(requestContext.params.id));
        if (isNull(profile)) {
            return variables.response.notFound("Profile not found");
        }
        return variables.response.ok({ "profile": profile });
    }

    public struct function updateMine(required struct requestContext) {
        var body = requestContext.body;
        var profile = variables.profiles.updateMine(
            userId = requestContext.user.id,
            careServices = structKeyExists(body, "careServices") ? toString(body.careServices) : "",
            location = structKeyExists(body, "location") ? toString(body.location) : "",
            bio = structKeyExists(body, "bio") ? toString(body.bio) : ""
        );
        return variables.response.ok({ "profile": profile });
    }

}
