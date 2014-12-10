package au.org.ala.taxonoverflow.marshal

import grails.converters.JSON

import java.text.SimpleDateFormat

abstract class AbstractJSONMarshaller<T> implements ICustomJSONMarshaller {

    private SimpleDateFormat _sdf = new SimpleDateFormat("yyyy-MM-dd")

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
            registerImpl(t, data)
            return data
        }

    }

    protected abstract void registerImpl(T obj, Map result);

    protected abstract Class<T> getWrappedClass();

}

interface ICustomJSONMarshaller {
    void register()
}


