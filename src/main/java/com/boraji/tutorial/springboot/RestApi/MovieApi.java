package com.boraji.tutorial.springboot.RestApi;

import com.boraji.tutorial.springboot.Models.MovieParam;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.HashMap;
import java.util.Map;

@RestController
public class MovieApi {
    @GetMapping("/GetMovieList")
    public String getMovieList(MovieParam movieParam){

        HashMap<String, Object> result = new HashMap<String, Object>();

        String jsonInString = "";

        try{

            //connection time out setting part
            /*HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
            factory.setConnectTimeout(5000);
            factory.setReadTimeout(5000);*/

            RestTemplate restTemplate = new RestTemplate();

            HttpHeaders headers = new HttpHeaders();
            HttpEntity<?> entity = new HttpEntity<>(headers);

            String urlFront = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchWeeklyBoxOfficeList.json";
            String urlParamKey = "?key=af37486b34faf383c8128272965a2fac";
            String urlParamTargetDt = "&targetDt=20200601";
            String url = urlFront + urlParamKey + urlParamTargetDt;
            UriComponents uri = UriComponentsBuilder.fromHttpUrl(url).build();

            ResponseEntity<Map> resultMap = restTemplate.exchange(uri.toString(), HttpMethod.GET, entity, Map.class);
            result.put("statusCode", resultMap.getStatusCodeValue());
            result.put("header", resultMap.getHeaders());
            result.put("body", resultMap.getBody());

            ObjectMapper mapper = new ObjectMapper();
            jsonInString = mapper.writeValueAsString(resultMap.getBody());



        }catch(HttpClientErrorException | HttpServerErrorException e){
            result.put("statusCode", e.getRawStatusCode());
            result.put("body", e.getStatusText());
            System.out.println("api error");
            System.out.println(e.toString());
        }catch (Exception e){
            result.put("StatusCode", "999");
            result.put("boby", "exception error");
            System.out.println(e.toString());
        }

        return jsonInString;
    }
}
