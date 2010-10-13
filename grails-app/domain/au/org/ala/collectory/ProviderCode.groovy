package au.org.ala.collectory

class ProviderCode {

    String code

    static auditable = [ignore: ['version']]

    static belongsTo = ProviderMap

    static mapping = {
        sort: 'code'
    }

    static constraints = {
        code(maxSize: 200, blank:false, unique:true)
    }

    String toString() {
        return code
    }

}
