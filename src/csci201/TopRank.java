package csci201;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import database.Database;
import database.RankUpdate;

/**
 * Servlet implementation class TopRank
 */
@WebServlet("/TopRank")
public class TopRank extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#service(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		/* database starts */
		// variables
		// for user
		if(request.getSession()==null) {
			System.out.println("lol");
		}
		boolean isLoggedin = false;
		if(request.getSession().getAttribute("loggedin")!=null) {
			isLoggedin = (boolean)request.getSession().getAttribute("loggedin");
		}else {
			isLoggedin = false;
			request.getSession().setAttribute("loggedin", false);
		}
		String username = (String)request.getSession().getAttribute("currentusername");
		int rankSelection = Integer.parseInt(request.getParameter("rank"));
		int limit = Integer.parseInt(request.getParameter("limit"));
		// 0: daily, 1: weekly, 2: monthly
		List<Post> posts = new ArrayList<Post>();

		// check if ranks are up to date
		new RankUpdate();
		
		// load posts
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		PreparedStatement ps2 = null;
		ResultSet rs2 = null;
		PreparedStatement ps3 = null;
		ResultSet rs3 = null;
		PreparedStatement ps4 = null;
		ResultSet rs4 = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/DogSpotting?user=root&password=root&useSSL=false");
			// get userID if loggedin
			int userID = 0;
			if(isLoggedin) {
				userID = Database.getUser(username).getUserID();
			}
			// get respective lists
			String[] rankOption = {"dailylike", "monthlylike", "yearlylike"};
			ps = conn.prepareStatement("SELECT * FROM Post p, User u " + 
					"WHERE p.userID = u.userID " + 
					"ORDER BY " + rankOption[rankSelection] + " DESC, " +
					"timestamp " +
					"LIMIT " + limit);
			rs = ps.executeQuery();
			// for each post
			ps2 = conn.prepareStatement("SELECT c.commentID, u.username, u.picture, c.content FROM Comment c, User u " + 
					"WHERE postID=? AND c.userID = u.userID");
			if(isLoggedin) {
				ps3 = conn.prepareStatement("SELECT * FROM Likes WHERE userID = ? AND postID = ? AND valid = 1");
				ps3.setInt(1, userID);
				ps4 = conn.prepareStatement("Select * FROM Follow WHERE followerID = ? AND followingID = ? AND valid = 1");
				ps4.setInt(1, userID);
			}
			while (rs.next()) { // load ranked posts
				// load tags
				List<String> tags = new ArrayList<String>();
				if(rs.getString("tag1") != null) { tags.add(rs.getString("tag1")); }
				if(rs.getString("tag2") != null) { tags.add(rs.getString("tag2")); }
				if(rs.getString("tag3") != null) { tags.add(rs.getString("tag3")); }
				if(rs.getString("tag4") != null) { tags.add(rs.getString("tag4")); }
				if(rs.getString("tag5") != null) { tags.add(rs.getString("tag5")); }
				// load comments
				int postID = rs.getInt("postID");
				List<Comment> comments = new ArrayList<Comment>();
				ps2.setLong(1, postID);
				rs2 = ps2.executeQuery();
				while(rs2.next()) {
					Comment tempComment = new Comment(rs2.getInt("commentID"), rs2.getString("username"),  rs2.getString("content"));
					comments.add(tempComment);
				}
				Post tempPost = new Post(postID, rs.getInt("lifelike"), rs.getString("image"), rs.getString("username"), rs.getString("picture"), rs.getString("description"), tags, comments);
				// check like and comment if loggedin
				if(isLoggedin) {
					ps3.setInt(2, postID);
					rs3 = ps3.executeQuery();
					if(rs3.next()) {
						tempPost.setIsLike(true);
					}

					int postUserID = rs.getInt("userID");
					ps4.setInt(2, postUserID);
					rs4 = ps4.executeQuery();
					if(rs4.next()) {
						tempPost.setIsFollow(true);
					}
				}
				posts.add(tempPost);
			}
		} catch (SQLException sqle) {
			System.out.println ("SQLException in TopRank: " + sqle.getMessage());
		} catch (ClassNotFoundException cnfe) {
			System.out.println ("ClassNotFoundException: " + cnfe.getMessage());
		} finally {
			try {
				if (conn != null) {
					conn.close();
				}
				if (rs != null) {
					rs.close();
				}
				if (ps != null) {
					ps.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
			try {
				if (rs2 != null) {
					rs2.close();
				}
				if (ps2 != null) {
					ps2.close();
				}
				if (ps3 != null) {
					ps3.close();
				}
				if (ps4 != null) {
					ps4.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
			try {
				if (rs3 != null) {
					rs3.close();
				}
				if (ps3 != null) {
					ps3.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
			try {
				if (rs4 != null) {
					rs4.close();
				}
				if (ps4 != null) {
					ps4.close();
				}
			} catch (SQLException sqle) {
				System.out.println("sqle: " + sqle.getMessage());
			}
		}
		/* database ends */
		
		/* output List<Post> posts */	
		Gson gson = new Gson();
		String json = gson.toJson(posts);
	    response.setContentType("application/json");
	    response.setCharacterEncoding("UTF-8");
	    response.getWriter().write(json);
	}

}