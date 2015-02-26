package au.org.ala.taxonoverflow.marshal

import au.org.ala.taxonoverflow.BiocacheService
import au.org.ala.taxonoverflow.EcodataService
import grails.converters.JSON

import java.text.SimpleDateFormat

abstract class AbstractJSONMarshaller<T> implements ICustomJSONMarshaller {

    private SimpleDateFormat _sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss")
    private BiocacheService _biocacheService
    private EcodataService _ecodataService

    protected String formatDate(Date date) {
        if (date) {
            return _sdf.format(date)
        }
        return null
    }

    @Override
    public void register() {
        def cc = getWrappedClass()
        JSON.registerObjectMarshaller(cc) { T t ->
            def data = [:]
            marshalObject(t, data)
            return data
        }
    }

    @Override
    void setBiocacheService(BiocacheService biocacheService) {
        _biocacheService = biocacheService
    }

    @Override
    void setEcodataService(EcodataService ecodataService) {
        _ecodataService = ecodataService
    }

    protected EcodataService getEcodataService() {
        return _ecodataService
    }

    protected BiocacheService getBiocacheService() {
        return _biocacheService
    }

    protected abstract void marshalObject(T obj, Map result);

    protected abstract Class<T> getWrappedClass();

}

interface ICustomJSONMarshaller {
    void register()
    void setBiocacheService(BiocacheService biocacheService)
    void setEcodataService(EcodataService ecodataService)
}


