package csci201;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class CommentPost
 */
@WebServlet("/CommentPost")
public class CommentPost extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#service(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		/* database starts */
		// variables
		int postID = Integer.parseInt(request.getParameter("postid"));
		String username = (String) request.getSession().getAttribute("currentusername");
		String content = request.getParameter("comment");
		System.out.println("hi");
		Post post = null;

		int commentID = 1;
		boolean isOnPost = true; // change here!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		if(!isOnPost) {
			commentID = 3; // change here!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		}

		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/DogSpotting?user=root&password=root&useSSL=false");
			// find userID
			ps = conn.prepareStatement("SELECT userID FROM User WHERE username=?");
			ps.setString(1, username); // set first variable in prepared statement
			rs = ps.executeQuery();
			int userID = 0;
			while (rs.next()) { // get userID
				userID = rs.getInt("userID");
			}
			ps.close();
			// insert new comment
			if(isOnPost) {
				ps = conn.prepareStatement("INSERT INTO Comment (userID, postID, content) VALUES (?, ?, ?)");
				ps.setLong(1, userID);
				ps.setLong(2, postID);
				ps.setString(3, content);
				ps.executeUpdate();
				ps.close();
				rs.close();
			}else {
				ps = conn.prepareStatement("INSERT INTO Comment (userID, refcommentID, content) VALUES (?, ?, ?)");
				ps.setLong(1, userID);
				ps.setLong(2, commentID);
				ps.setString(3, content);
				ps.executeUpdate();
				ps.close();
				rs.close();
			}
			
			// re-fetch post
			ps = conn.prepareStatement(
                    "SELECT u.username, p.postID, p.image, p.description, p.tag1, p.tag2, p.tag3, p.tag4, p.tag5 "
                            + " FROM User u, Post p" + " WHERE u.userID=p.userID AND postID=?");
			ps.setLong(1, postID); // set first variable in prepared statement
			rs = ps.executeQuery();
			// check if user exists and check password
			while (rs.next()) {
				// load tags
				List<String> tags = new ArrayList<String>();
				if(rs.getString("tag1") != null) { tags.add(rs.getString("tag1")); }
				if(rs.getString("tag2") != null) { tags.add(rs.getString("tag2")); }
				if(rs.getString("tag3") != null) { tags.add(rs.getString("tag3")); }
				if(rs.getString("tag4") != null) { tags.add(rs.getString("tag4")); }
				if(rs.getString("tag5") != null) { tags.add(rs.getString("tag5")); }
				// load comments
				List<Comment> comments = new ArrayList<Comment>();
				ps2 = conn.prepareStatement("SELECT c.commentID, u.username, c.content FROM Comment c, User u " + 
						"WHERE postID=? AND c.userID = u.userID ORDER BY commentID ASC");
				ps2.setLong(1, postID); // set first variable in prepared statement
				rs2 = ps2.executeQuery();
				while(rs2.next()) {
					Comment tempComment = new Comment(rs2.getInt("commentID"), rs2.getString("username"), rs2.getString("content"));
					tempComment.getCommentOnThis();
					comments.add(tempComment);
				}
				post = new Post(postID, rs.getString("image"), rs.getString("username"), rs.getString("description"), tags, comments);
			}
		} catch (SQLException sqle) {
			System.out.println ("SQLException: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println ("ClassNotFoundException: " + cnfe.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
				}
				if (ps != null) {
					ps.close();
				}
				if (conn != null) {
					conn.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
		/* database ends */
		
		/* output Post post */
		
		String pageToForward = "/IndividualPost.jsp";
		request.setAttribute("post", post);
		RequestDispatcher dispatch = getServletContext().getRequestDispatcher(pageToForward);
		dispatch.forward(request, response);
	}

}
