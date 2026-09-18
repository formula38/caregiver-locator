component {

    public any function init() {
        variables.response = new lib.Response();
        return this;
    }

    public struct function show(required struct requestContext) {
        return variables.response.ok({ "status": "ok" });
    }

}
