var questionSample = {
    "_index": "taxonoverflow",
    "_type": "question",
    "_id": "4",
    "_version": 6,
    "found": true,
    "_source": {
        "id": 4,
        "user": {
            "id": 3,
            "alaUserId": "11069"
        },
        "questionType": "Identification",
        "occurrenceId": "b185ec97-7155-4207-b8c1-b0f64244f1a7",
        "source": "biocache",
        "comments": [],
        "answers": [],
        "tags": [
            {
                "questionId": 4,
                "tag": "kangaroo",
                "dateCreated": "2015-03-03T13:36:38"
            }
        ],
        "views": [],
        "dateCreated": "2015-03-03T02:36:38Z",
        "viewCount": 0,
        "answerCount": 0,
        "occurrence": {
            "occurrenceId": "b185ec97-7155-4207-b8c1-b0f64244f1a7",
            "scientificName": "Macropus giganteus",
            "commonName": "Eastern Grey Kangaroo",
            "recordedBy": "Bernard DUPONT",
            "userId": null,
            "eventDate": "2013-09-22",
            "locality": "Cape Hillsborough",
            "decimalLatitude": "-20.924385",
            "decimalLongitude": "149.047629",
            "coordinateUncertaintyInMeters": "16.0",
            "occurrenceRemarks": "Cape Hillsborough NP, Central Queensland, AUSTRALIA\n\nScanned Slide from Dec 2000",
            "locationRemarks": null,
            "imageIds": ["1adc0b02-726d-4586-a997-13643f3bb66f"],
            "imageUrls": ["http://images.ala.org.au/image/proxyImageThumbnail?imageId=1adc0b02-726d-4586-a997-13643f3bb66f"]
        }
    }
};

//Aggregate by tags
var query1 = {
    "size": 0,
    "aggs": {
        "tags": {
            "terms": {"field": "tags.tag"}
        }
    }
};

var query2 = {
    "size": 0,
    "aggs": {
        "questionTypes": {
            "terms": {"field": "questionType"}
        }
    }
};