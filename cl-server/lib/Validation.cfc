component {

    public array function requireFields(required struct data, required array fields) {
        var errors = [];
        for (var field in fields) {
            if (!structKeyExists(data, field) || !len(trim(toString(data[field])))) {
                arrayAppend(errors, field & " is required");
            }
        }
        return errors;
    }

    public array function oneOf(required any value, required array allowed, required string field) {
        if (!arrayFindNoCase(allowed, toString(value))) {
            return [field & " must be one of: " & arrayToList(allowed, ", ")];
        }
        return [];
    }

    public array function emailFormat(required string email) {
        if (!reFindNoCase("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$", trim(email))) {
            return ["email must be a valid address"];
        }
        return [];
    }

    public array function minLength(required string value, required numeric min, required string field) {
        if (len(value) < min) {
            return [field & " must be at least " & min & " characters"];
        }
        return [];
    }

    public array function integerInRange(required any value, required numeric min, required numeric max, required string field) {
        if (!isNumeric(value) || val(value) != int(val(value))) {
            return [field & " must be an integer"];
        }
        var n = int(val(value));
        if (n < min || n > max) {
            return [field & " must be between " & min & " and " & max];
        }
        return [];
    }

    public array function merge(required array left, required array right) {
        var combined = duplicate(left);
        for (var item in right) {
            arrayAppend(combined, item);
        }
        return combined;
    }

}
