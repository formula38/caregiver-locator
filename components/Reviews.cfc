component persistent="true" {
    property name="id" fieldtype="id" generator="native";
    property name="providerId" fieldtype="many-to-one" cfc="CareProvider" fkcolumn="providerId";
    property name="userId" fieldtype="many-to-one" cfc="Users" fkcolumn="userId";
    property name="rating" ormtype="integer" notnull="true";
    property name="reviewText" ormType="text";

    // Relationships: Many-to-One relationship with CareProviders and Users
}