component {

    public query function execute(required string sql, any params = []) {
        var ds = structKeyExists(application, "datasourceName") ? application.datasourceName : "caregiver";
        return queryExecute(sql, params, { datasource: ds });
    }

    public struct function p(required any value, string sqltype = "cf_sql_varchar", boolean nullable = false) {
        var empty = isSimpleValue(value) && !len(toString(value));
        var param = { value: value, cfsqltype: sqltype };
        if (nullable && empty) {
            param.null = true;
        }
        return param;
    }

    public array function toArray(required query qry) {
        var rows = [];
        for (var row in qry) {
            arrayAppend(rows, row);
        }
        return rows;
    }

    public any function first(required query qry) {
        if (qry.recordCount == 0) {
            return;
        }
        return toArray(qry)[1];
    }

}
