package pe.edu.vallegrande.umamicroservice.dto;

public class InstitutionDto {
    private String id;

    private String name;

    private String correoContacto;

    public InstitutionDto(String id, String name, String correoContacto) {
        this.id = id;
        this.name = name;
        this.correoContacto = correoContacto;
    }

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getCorreoContacto() {
        return correoContacto;
    }
}
