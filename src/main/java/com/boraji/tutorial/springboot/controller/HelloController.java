package com.boraji.tutorial.springboot.controller;

import com.boraji.tutorial.springboot.Models.MovieParam;
import com.boraji.tutorial.springboot.RestApi.MovieApi;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;

@Controller
public class HelloController {

    @Autowired
    MovieApi movieApi;

    @RequestMapping("/")
    public String movieView() {
        return "movie";
    }

    @RequestMapping("/index")
    public String index() {
       return "index";
    }

    @PostMapping("/hello")
    public String sayHello(@RequestParam("name") String name, Model model) {
        model.addAttribute("name", name);
        return "hello";
    }

    @RequestMapping("/dateRangeMovieList")
    public String dateRangeMovieList(Model model, MovieParam movieParam){

        return "movie";
    }
}
