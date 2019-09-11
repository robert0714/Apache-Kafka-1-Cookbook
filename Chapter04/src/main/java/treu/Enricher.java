package treu; 
 
import com.fasterxml.jackson.databind.*; 
import com.fasterxml.jackson.databind.node.ObjectNode; 
import com.maxmind.geoip.Location; 
import treu.extractors.GeoIP; 
import treu.extractors.OpenWeather; 
 
import java.io.IOException; 
 
import org.apache.kafka.clients.producer.*; 
 
public class Enricher implements doubloon.Producer {
 
  private final KafkaProducer<String, String> producer; 
  private final String enrichedTopic;
  private  String sourceTopic;
 
  protected static final ObjectMapper MAPPER = new ObjectMapper(); 
 
  public Enricher(String servers, String enrichedTopic) { 
    this.producer = new KafkaProducer(doubloon.Producer.createConfig(servers));
    this.enrichedTopic = enrichedTopic; 
  }

  public Enricher(String servers, String sourceTopic, String enrichedTopic) {
      this (servers,enrichedTopic);
      this.sourceTopic = sourceTopic;
  }

  @Override 
  public void process(String message) { 
 
    try { 
      JsonNode root = MAPPER.readTree(message); 
      JsonNode ipAddressNode = root.path("ipAddress"); 
       
      if (!ipAddressNode.isMissingNode()) { 
        String ipAddress = ipAddressNode.textValue(); 
 
        Location location = new GeoIP().getLocation(ipAddress);          //1  
 
        OpenWeather ow = new OpenWeather();                              //2 
        ((ObjectNode) root).with("location").put("temperature", 
                ow.getTemperature(location.latitude + "",  
                                  location.longitude + ""));             //3 

        doubloon.Producer.write(this.producer, this.enrichedTopic,
                MAPPER.writeValueAsString(root));                        //4 
      } 
    } catch (IOException e) { 
       // deal with exception 
    } 
  } 

} 