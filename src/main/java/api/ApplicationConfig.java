package api;

import jakarta.ws.rs.ApplicationPath;
import jakarta.ws.rs.core.Application;
import java.util.HashSet;
import java.util.Set;

@ApplicationPath("/api")
public class ApplicationConfig extends Application {
    @Override
    public Set<Class<?>> getClasses() {
        Set<Class<?>> resources = new HashSet<>();
        // Add your resources here
        resources.add(ProductService.class);
        resources.add(ClientService.class);
        resources.add(InvoiceService.class);
        return resources;
    }
}
