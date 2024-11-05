<cfscript>
// Get search parameters from URL
    location = url.location ?: "";
    maxPrice = url.maxPrice ?: 0;
    subsidiesAvailable = url.subsidiesAvailable ?: false;

    childcareService = new components.ChildcareService();
    childcareResults = childcareService.searchProviders(location, maxPrice, subsidiesAvailable);

// Loop through results
    if (arrayLen(childcareResults) > 0) {
        for (var provider in childcareResults) {
            writeOutput("<div>");
            writeOutput("<h3>#provider.name#</h3>");
            writeOutput("<p>Location: #provider.location#</p>");
            writeOutput("<p>Price: $ #provider.price#</p>");
            writeOutput("<p>Subsidies Available: #provider.subsidiesAvailable#</p>");
            writeOutput("<div>");
        }
    } else {
        writeOutput("<p>No childcare providers found.</p>");
    }
</cfscript>
