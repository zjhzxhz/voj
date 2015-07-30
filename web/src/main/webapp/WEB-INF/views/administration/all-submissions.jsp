<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${language}" />
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:eval expression="@propertyConfigurer.getProperty('url.cdn')" var="cdnUrl" />
<!DOCTYPE html>
<html lang="${language}">
<head>
    <meta charset="UTF-8">
    <title><spring:message code="voj.administration.all-submissions.title" text="Submissions" /> | ${websiteName}</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="${description}">
    <meta name="author" content="谢浩哲">
    <!-- Icon -->
    <link href="${cdnUrl}/img/favicon.ico" rel="shortcut icon" type="image/x-icon">
    <!-- StyleSheets -->
    <link rel="stylesheet" type="text/css" href="${cdnUrl}/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="${cdnUrl}/css/bootstrap-responsive.min.css" />
    <link rel="stylesheet" type="text/css" href="${cdnUrl}/css/flat-ui.min.css" />
    <link rel="stylesheet" type="text/css" href="${cdnUrl}/css/font-awesome.min.css" />
    <link rel="stylesheet" type="text/css" href="${cdnUrl}/css/administration/style.css" />
    <link rel="stylesheet" type="text/css" href="${cdnUrl}/css/administration/all-submissions.css" />
    <!-- JavaScript -->
    <script type="text/javascript" src="${cdnUrl}/js/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="${cdnUrl}/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${cdnUrl}/js/flat-ui.min.js"></script>
    <script type="text/javascript" src="${cdnUrl}/js/md5.min.js"></script>
    <script type="text/javascript" src="${cdnUrl}/js/pace.min.js"></script>
    <!--[if lte IE 9]>
        <script type="text/javascript" src="${cdnUrl}/js/jquery.placeholder.min.js"></script>
    <![endif]-->
    <!--[if lte IE 7]>
        <script type="text/javascript"> 
            window.location.href='<c:url value="/not-supported" />';
        </script>
    <![endif]-->
</head>
<body>
    <div id="wrapper">
        <!-- Sidebar -->
        <%@ include file="/WEB-INF/views/administration/include/sidebar.jsp" %>
        <div id="container">
            <!-- Header -->
            <%@ include file="/WEB-INF/views/administration/include/header.jsp" %>
            <!-- Content -->
            <div id="content">
                <h2 class="page-header"><i class="fa fa-code"></i> <spring:message code="voj.administration.all-submissions.all-submissions" text="Submissions" /></h2>
                <div class="alert alert-error hide"></div> <!-- .alert-error -->
                <div id="filters" class="row-fluid">
                    <div class="span6">
                    	<select id="actions">
                            <option value="delete"><spring:message code="voj.administration.all-submissions.delete" text="Delete" /></option>
                            <option value="restart"><spring:message code="voj.administration.all-submissions.restart" text="Restart" /></option>
                        </select>
                        <button class="btn btn-primary"><spring:message code="voj.administration.all-submissions.apply" text="Apply" /></button>
                    </div> <!-- .span6 -->
                    <div class="span6">
                        <div id="pagination" class="pagination">
                            <c:set var="lowerBound" value="${currentPage - 5 > 0 ? currentPage - 5 : 1}" />
                            <c:set var="upperBound" value="${currentPage + 5 < totalPages ? currentPage + 5 : totalPages}" />
                            <ul>
                                <li class="previous <c:if test="${currentPage <= 1}">disabled</c:if>">
                                <a href="
                                <c:choose>
                                	<c:when test="${currentPage <= 1}">javascript:void(0);</c:when>
                                	<c:otherwise><c:url value="/administration/all-submissions?page=${currentPage - 1}" /></c:otherwise>
                                </c:choose>
                                ">&lt;</a>
                                </li>
                                <c:forEach begin="${lowerBound}" end="${upperBound}" var="pageNumber">
                                <li <c:if test="${pageNumber == currentPage}">class="active"</c:if>><a href="<c:url value="/administration/all-submissions?page=${pageNumber}" />">${pageNumber}</a></li>
                                </c:forEach>
                                <li class="next <c:if test="${currentPage >= totalPages}">disabled</c:if>">
                                <a href="
                                <c:choose>
                                	<c:when test="${currentPage >= totalPages}">javascript:void(0);</c:when>
                                	<c:otherwise><c:url value="/administration/all-submissions?page=${currentPage + 1}" /></c:otherwise>
                                </c:choose>
                                ">&gt;</a>
                                </li>
                            </ul>
                        </div> <!-- #pagination-->
                    </div> <!-- .span6 -->
                </div> <!-- .row-fluid -->
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th class="check-box">
                                <label class="checkbox" for="all-submissions">
                                    <input id="all-submissions" type="checkbox" data-toggle="checkbox">
                                </label>
                            </th>
                            <th class="flag"><spring:message code="voj.submissions.submissions.result" text="Result" /></th>
                            <th class="score"><spring:message code="voj.submissions.submissions.score" text="Score" /></th>
                            <th class="time"><spring:message code="voj.submissions.submissions.time" text="Time" /></th>
                            <th class="memory"><spring:message code="voj.submissions.submissions.memory" text="Memory" /></th>
                            <th class="name"><spring:message code="voj.submissions.submissions.problem" text="Problem" /></th>
                            <th class="user"><spring:message code="voj.submissions.submissions.user" text="User" /></th>
                            <th class="language"><spring:message code="voj.submissions.submissions.language" text="Language" /></th>
                            <th class="submit-time"><spring:message code="voj.submissions.submissions.submit-time" text="Submit Time" /></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="submission" items="${submissions}">
                        <tr data-value="${submission.submissionId}">
                            <td class="check-box">
                                <label class="checkbox" for="submission-${submission.submissionId}">
                                    <input id="submission-${submission.submissionId}" type="checkbox" value="${submission.submissionId}" data-toggle="checkbox" />
                                </label>
                            </td>
                            <td class="flag flag-${submission.judgeResult.judgeResultSlug}"><a href="<c:url value="/administration/edit-submission?submissionId=${submission.submissionId}" />">${submission.judgeResult.judgeResultName}</a></td>
                            <td class="score">${submission.judgeScore}</td>
                            <td class="time">${submission.usedTime} ms</td>
                            <td class="memory">${submission.usedMemory} K</td>
                            <td class="name"><a href="<c:url value="/administration/edit-problem?problemId=${submission.problem.problemId}" />">P${submission.problem.problemId} ${submission.problem.problemName}</a></td>
                            <td class="user"><a href="<c:url value="/administration/edit-user?uid=${submission.user.uid}" />">${submission.user.username}</a></td>
                            <td class="language">${submission.language.languageName}</td>
                            <td class="submit-time">
                                <fmt:formatDate value="${submission.submitTime}" type="both" dateStyle="default" timeStyle="default" />
                            </td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div> <!-- #content -->
        </div> <!-- #container -->
    </div> <!-- #wrapper -->
    <!-- Java Script -->
    <!-- Placed at the end of the document so the pages load faster -->
    <%@ include file="/WEB-INF/views/administration/include/footer-script.jsp" %>
    <script type="text/javascript">
        $('label[for=all-submissions]').click(function() {
        	// Fix the bug for Checkbox in FlatUI 
        	var isChecked = false;
        	setTimeout(function() {
        		isChecked = $('label[for=all-submissions]').hasClass('checked');
        		
        		if ( isChecked ) {
            		$('label.checkbox').addClass('checked');
            	} else {
            		$('label.checkbox').removeClass('checked');
            	}
        	}, 100);
        });
    </script>
    <script type="text/javascript">
        $('button.btn-primary', '#filters').click(function() {
            var submissions = [],
                action      = $('#actions').val();

            $('label.checkbox').each(function() {
                if ( $(this).hasClass('checked') ) {
                    var submissionId = $('input[type=checkbox]', $(this)).val();
                    submissions.push(submissionId);
                }
            });

            if ( action == 'delete' ) {
                return doDeleteSubmissionsAction(submissions);
            } else if ( action == 'restart' ) {
                return doRestartSubmissionsAction(submissions);
            }
        });
    </script>
    <script type="text/javascript">
        function doDeleteSubmissionsAction(submissions) {
            var postData = {
                'submissions': JSON.stringify(submissions)
            };

            $.ajax({
                type: 'POST',
                url: '<c:url value="/administration/deleteSubmissions.action" />',
                data: postData,
                dataType: 'JSON',
                success: function(result){
                    if ( result['isSuccessful'] ) {
                        for ( var i = 0; i < submissions.length; ++ i ) {
                            $('tr[data-value=%s]'.format(submissions[i])).remove();
                        }
                    } else {
                        $('.alert').html('<spring:message code="voj.administration.all-submissions.delete-error" text="Some errors occurred while deleting submissions." />');
                        $('.alert').removeClass('hide');
                    }
                }
            });
        }
    </script>
    <script type="text/javascript">
        function doRestartSubmissionsAction(submissions) {
            var postData = {
                'submissions': JSON.stringify(submissions)
            };

            $.ajax({
                type: 'POST',
                url: '<c:url value="/administration/restartSubmissions.action" />',
                data: postData,
                dataType: 'JSON',
                success: function(result){
                    if ( result['isSuccessful'] ) {
                        for ( var i = 0; i < submissions.length; ++ i ) {
                            var submission  = $('tr[data-value=%s]'.format(submissions[i])),
                                judgeResult = $('td.flag', $(submission)); 

                            $(judgeResult).removeClass();
                            $(judgeResult).addClass('flag flag-PD');
                            $('a', $(judgeResult)).html('Pending');
                        }
                    } else {
                        $('.alert').html('<spring:message code="voj.administration.all-submissions.restart-error" text="Some errors occurred while restarting judging for submissions." />');
                        $('.alert').removeClass('hide');
                    }
                }
            });
        }
    </script>
    <c:if test="${GoogleAnalyticsCode != ''}">
    <script type="text/javascript">${googleAnalyticsCode}</script>
    </c:if>
</body>
</html>