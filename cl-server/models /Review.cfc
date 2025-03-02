component persistent="true" table="reviews" {
    property name="id" fieldtype="id" generator="native";
    property name="reviewerId" type="int";
    property name="revieweeId" type="int";
    property name="rating" type="int";
    property name="comment" type="string";
    property name="createdAt" type="timestamp";
}
