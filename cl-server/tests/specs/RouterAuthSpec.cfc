component displayName="RouterAuthSpec" extends="testbox.system.BaseSpec" {

    function run() {
        describe("Router authorization", function () {
            it("rejects protected routes without a bearer token", function () {
                var router = new config.Router();
                var result = router.handle(
                    method = "GET",
                    path = "/api/users/me",
                    headers = {},
                    body = {},
                    queryString = {}
                );
                expect(result.status).toBe(401);
                expect(result.body.ok).toBeFalse();
            });

            it("allows the health check without auth", function () {
                var router = new config.Router();
                var result = router.handle(
                    method = "GET",
                    path = "/api/health",
                    headers = {},
                    body = {},
                    queryString = {}
                );
                expect(result.status).toBe(200);
                expect(result.body.data.status).toBe("ok");
            });
        });
    }

}
