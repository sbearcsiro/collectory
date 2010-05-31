package au.org.ala.collectory

/**
 * Represents a scientific name associated with an infosource.
 */
class ScientificName implements Serializable {

    String name             // the scientific name
    String guid             // a unique identifier of the name that allows auto-completion

    static belongsTo = InfoSource

    static constraints = {
        name(blank:false, maxSize:256)
        guid(blank:false, maxSize:256)
    }
}
