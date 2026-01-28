{
    "name": "Real Estate",
    "version": "1.0",
    "category": "Real Estate",
    "author": "Muhammad Nuralimsyah",
    "website": "github.com/nuralims",
    "description": "Real Estate",
    "depends": [
        "base"
    ],
    "application": True,
    "data" : [
        "security/ir.model.access.csv",
        "views/estate_property_views.xml",
        "views/estate_property_type_views.xml",
        "views/estate_menu.xml",
    ],
    "demo": [
        "demo/estate_property_type_demo.xml",
        "demo/estate_property_demo.xml",
    ]
}