package au.org.ala.taxonoverflow

import ognl.Ognl
import net.sf.json.JSONObject

class OccurrenceHelper {

    private JSONObject _occurrence

    private OccurrenceHelper(JSONObject occurrence) {
        _occurrence = occurrence
    }

    public static Coordinates getCoordinates(JSONObject occurrence) {
        def instance = new OccurrenceHelper(occurrence)

        Double latitude = instance.getDouble("decimalLatitude")
        Double longitude = instance.getDouble("decimalLongitude")
        if (latitude && longitude) {
            return new Coordinates(latitude: latitude, longitude: longitude)
        }

        return null
    }

    private Double getDouble(String path) {
        def result = Ognl.getValue(path, _occurrence)
        if (result) {
            return Double.parseDouble(result.toString())
        }
        return null
    }
}

class Coordinates {
    double latitude
    double longitude
}
