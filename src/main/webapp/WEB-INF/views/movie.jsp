<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Movie Test</title>

    <link rel="canonical" href="https://getbootstrap.com/docs/4.0/examples/sticky-footer-navbar/">
    <link href="/resources/css/bootstrap.css" rel="stylesheet">
    <link href="/resources/css/sticky-footer-navbar.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.10.21/css/jquery.dataTables.min.css" rel="stylesheet">

    <script src="/resources/js/jquery-3.5.1.min.js"></script>
    <script src="/resources/js/jquery.min.js"></script>
    <script src="/resources/js/datatables.min.js"></script>
    <script src="/resources/js/popper.min.js"></script>
    <script src="/resources/js/bootstrap.min.js"></script>
</head>

<body>
<div id="app">
    <header>
        <!-- Fixed navbar -->
        <nav class="navbar navbar-expand-md navbar-dark fixed-top bg-dark">
            <a class="navbar-brand" href="#">Weekly Box Office</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarCollapse"
                    aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarCollapse">
                <ul class="navbar-nav mr-auto">
                    <li class="nav-item active">
                        <a class="nav-link" href="#">Home <span class="sr-only">(current)</span></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Link</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link disabled" href="#">Disabled</a>
                    </li>
                </ul>
                <form class="form-inline mt-2 mt-md-0">
                    <input class="form-control mr-sm-2" type="text" placeholder="Search" aria-label="Search">
                    <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
                </form>
            </div>
        </nav>
    </header>

    <!-- Begin page content -->
    <main role="main" class="container">
        <h3 id="movieListNameId" class="mt-5"></h3>
        <table id="dtTableId">
            <thead>
            <tr>
                <th>Rank</th>
                <th>Release Date</th>
                <th>Movie Name</th>
                <th>Total Att Count</th>
            </tr>
            </thead>
        </table>
    </main>

    <footer class="footer">
        <div class="container">
            <span class="text-muted">Place sticky footer content here.</span>
        </div>
    </footer>
</div>
<div id="loadingId" class="LoadingBack"></div>
<div class="custom-popupBackground" style="display:none;"></div>
<div class="custom-popup" style="display:none;">

    <div style="width: 100%;height: 30px; background-color: ghostwhite; position: relative;border-bottom: 1px solid #bcbcbc;">
        <p id="popUpNameId" style="text-align: center; font: inherit; color: black;margin-top:10px;"></p>
    </div>
    <div>
        <img id="postImgId" src="" alt="no picture" style="width:65%;height:50%;margin-left: 17%; margin-top:10px;">
    </div>
</div>


<!-- Bootstrap core JavaScript
================================================== -->
<script type="text/javascript">
    $(document).ready(function () {

        var dtTable = $('#dtTableId').DataTable({
            destroy   : true,
            dom       : 'l<"right" Bf>rtip',
            buttons   : [{
                text  : 'Download',
                extend: 'excelHtml5'
            }],
            columnDefs: [
                {targets: [0, 1, 2, 3], className: 'text-center'},
            ],
            order     : [[0, 'asc']]
        });

        // datatable 클릭 시 이벤트
        $('#dtTableId').on('click', 'tr', function () {

            //sorting 쪽 클릭시에도 이벤트를 타기 때문에 validation 처리를 해줘야한다.
            if (dtTable.row(this).data() == undefined) return;
            //alert(dtTable.row(this).data());
            GetMovieImg(dtTable.row(this).data()[2]);
        });

        $('.custom-popupBackground').on('click', function () {
            $('.custom-popupBackground').css('display', 'none');
            $('.custom-popup').css('display', 'none');
        });
    });

    // url로 직접 가져오기
    GetMovieData = function () {
        var movieUrl = 'http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchWeeklyBoxOfficeList.json';
        $.ajax({
            type   : 'get',
            url    : movieUrl,
            data   : {
                key     : 'af37486b34faf383c8128272965a2fac',
                targetDt: '20200601'
            },
            success: function (result) {
                $("#loadingId").css("display", "none");
                if (result == undefined) return;

                console.log(result);
                var resultData = result.boxOfficeResult;
                console.log(resultData.weeklyBoxOfficeList);
                $("#movieListNameId").text('Weekend Movie Top 10 List' + ' (' + resultData.showRange + ')');

                $('#dtTableId').dataTable().fnClearTable();
                for (var i = 0; i < resultData.weeklyBoxOfficeList.length; i++) {
                    $('#dtTableId').dataTable().fnAddData(
                        [
                            resultData.weeklyBoxOfficeList[i].rank,
                            resultData.weeklyBoxOfficeList[i].openDt,
                            resultData.weeklyBoxOfficeList[i].movieNm,
                            resultData.weeklyBoxOfficeList[i].audiAcc
                        ]
                    );
                }

            },
            fail   : function (error) {
                console.error(error);
            }
        });
    }

    GetMovieList = function () {
        $.ajax({
            type   : 'get',
            url    : 'http://localhost:8080/GetMovieList',
            data   : null,
            success: function (result) {
                console.log(JSON.parse(result));
            },
            fail   : function (error) {
                console.error(error);
            }
        });
    }

    GetMovieImg = function (movieNM) {
        if (movieNM == "" | null) return;

        $.ajax({
            type   : 'get',
            url    : "https://movie.naver.com/movie/search/result.nhn",
            data   : {
                query  : movieNM.trim(),
                section: 'all',
                ie     : 'utf8'
            },
            success: function (result) {

                var imgUrl = $($($(result).find('.search_list_1').children()[0]).find('p')).find('img').attr("src");
                console.log(imgUrl);
                $('#postImgId').attr("src", imgUrl);
                $('#popUpNameId').text(movieNM);
                $('.custom-popupBackground').css('display', 'block');
                $('.custom-popup').css('display', 'block');

            },
            fail   : function (error) {
                console.error(error);
            }
        });

    }

    GetMovieData();


</script>
<!-- Placed at the end of the document so the pages load faster -->
</body>
</html>

