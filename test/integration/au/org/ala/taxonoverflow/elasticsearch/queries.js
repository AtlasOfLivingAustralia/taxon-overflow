var taxonoverflow_index = {
    "taxonoverflow": {
        "aliases": {},
        "mappings": {
            "question": {
                "properties": {
                    "answerCount": {"type": "long"},
                    "answers": {
                        "properties": {
                            "accepted": {"type": "boolean"},
                            "comments": {
                                "properties": {
                                    "answerId": {"type": "long"},
                                    "comment": {"type": "string"},
                                    "dateCreated": {
                                        "type": "date",
                                        "format": "dateOptionalTime"
                                    },
                                    "user": {
                                        "properties": {
                                            "alaUserId": {"type": "string"},
                                            "id": {"type": "long"}
                                        }
                                    }
                                }
                            },
                            "dateCreated": {
                                "type": "date",
                                "format": "dateOptionalTime"
                            },
                            "description": {"type": "string"},
                            "id": {"type": "long"},
                            "questionId": {"type": "long"},
                            "scientificName": {"type": "string"},
                            "user": {
                                "properties": {
                                    "alaUserId": {"type": "string"},
                                    "id": {"type": "long"}
                                }
                            },
                            "votes": {
                                "properties": {
                                    "answerId": {"type": "long"},
                                    "dateCreated": {
                                        "type": "date",
                                        "format": "dateOptionalTime"
                                    },
                                    "user": {
                                        "properties": {
                                            "alaUserId": {"type": "string"},
                                            "id": {"type": "long"}
                                        }
                                    },
                                    "voteValue": {"type": "long"}
                                }
                            }
                        }
                    },
                    "comments": {
                        "properties": {
                            "comment": {"type": "string"},
                            "dateCreated": {
                                "type": "date",
                                "format": "dateOptionalTime"
                            },
                            "questionId": {"type": "long"},
                            "user": {
                                "properties": {
                                    "alaUserId": {"type": "string"},
                                    "id": {"type": "long"}
                                }
                            }
                        }
                    },
                    "dateCreated": {
                        "type": "date",
                        "format": "dateOptionalTime"
                    },
                    "id": {"type": "long"},
                    "occurrence": {
                        "properties": {
                            "commonName": {"type": "string"},
                            "coordinateUncertaintyInMeters": {"type": "string"},
                            "decimalLatitude": {"type": "string"},
                            "decimalLongitude": {"type": "string"},
                            "eventDate": {
                                "type": "date",
                                "format": "dateOptionalTime"
                            },
                            "imageIds": {"type": "string"},
                            "imageUrls": {"type": "string"},
                            "locality": {"type": "string"},
                            "occurrenceId": {"type": "string"},
                            "occurrenceRemarks": {"type": "string"},
                            "recordedBy": {"type": "string"},
                            "scientificName": {"type": "string"},
                            "userId": {"type": "string"}
                        }
                    },
                    "occurrenceId": {"type": "string"},
                    "questionType": {"type": "string"},
                    "source": {"type": "string"},
                    "tags": {
                        "properties": {
                            "dateCreated": {
                                "type": "date",
                                "format": "dateOptionalTime"
                            },
                            "questionId": {"type": "long"},
                            "tag": {"type": "string"}
                        }
                    },
                    "user": {
                        "properties": {
                            "alaUserId": {"type": "string"},
                            "id": {"type": "long"}
                        }
                    },
                    "viewCount": {"type": "long"},
                    "views": {
                        "properties": {
                            "dateCreated": {
                                "type": "date",
                                "format": "dateOptionalTime"
                            },
                            "questionId": {"type": "long"},
                            "user": {
                                "properties": {
                                    "alaUserId": {"type": "string"},
                                    "id": {"type": "long"}
                                }
                            }
                        }
                    }
                }
            }
        },
        "settings": {
            "index": {
                "creation_date": "1425433467261",
                "uuid": "uGIh9yuMQ-yPA_laZ0UwMA",
                "aggs": {"questionTypes": {"terms": {"field": "questionType"}}},
                "number_of_replicas": "1",
                "number_of_shards": "5",
                "version": {"created": "1040499"}
            }
        },
        "warmers": {}
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

var query3 = {
    "filter": {
        "and" : [
            {
                "terms": {
                    "tags.tag": ["kangaroo"]
                }
            },
            {
                "or" : [
                    {
                        "range": {
                            "dateCreated" : {
                                "gte": "2015-03-02"
                            }
                        }
                    }
                ]

            }

        ]
    }
};

