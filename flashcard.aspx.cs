using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace WAPPSS
{
    public partial class flashcard : System.Web.UI.Page
    {
        public string ModeTypeFromDB = "light";
        protected int currentTCID = 0;
        protected int selectedDeckIdFromQuery = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Get ModeType from Mode table
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            if (Session["UserID"] != null)
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("SELECT TOP 1 ModeType FROM Mode WHERE UserID=@UserID", conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", Session["UserID"].ToString());
                        var mode = cmd.ExecuteScalar();
                        if (mode != null && mode != DBNull.Value)
                        {
                            ModeTypeFromDB = mode.ToString().Trim().ToLower();
                        }
                    }
                }
            }

            string courseName = Request.QueryString["course"];
            if (string.IsNullOrEmpty(courseName))
            {
                pnlCreateDeck.Visible = pnlCreateCard.Visible = pnlCards.Visible = false;
                pnlEditDeck.Visible = false;
                return;
            }
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT TC_ID FROM TeacherCourses WHERE TC_CourseName=@name", conn))
                {
                    cmd.Parameters.AddWithValue("@name", courseName);
                    var val = cmd.ExecuteScalar();
                    if (val == null)
                    {
                        pnlCreateDeck.Visible = pnlCreateCard.Visible = pnlCards.Visible = false;
                        pnlEditDeck.Visible = false;
                        return;
                    }
                    currentTCID = Convert.ToInt32(val);
                }
            }
            string deckIdQS = Request.QueryString["deck"];
            if (!string.IsNullOrEmpty(deckIdQS))
                int.TryParse(deckIdQS, out selectedDeckIdFromQuery);

            if (!IsPostBack)
            {
                BindDecks();
            }
        }

        protected void BindDecks()
        {
            ddlDecks.Items.Clear();
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT DeckID, DeckTitle FROM FlashcardDecks WHERE TC_ID=@tcid", conn))
                {
                    cmd.Parameters.AddWithValue("@tcid", currentTCID);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }
            ddlDecks.Items.Add(new System.Web.UI.WebControls.ListItem("-- Select Deck --", ""));
            foreach (DataRow row in dt.Rows)
            {
                ddlDecks.Items.Add(new System.Web.UI.WebControls.ListItem(row["DeckTitle"].ToString(), row["DeckID"].ToString()));
            }

            pnlCreateCard.Visible = false;
            pnlCards.Visible = false;
            pnlEditDeck.Visible = false;

            if (selectedDeckIdFromQuery > 0)
            {
                var item = ddlDecks.Items.FindByValue(selectedDeckIdFromQuery.ToString());
                if (item != null)
                {
                    ddlDecks.ClearSelection();
                    item.Selected = true;
                    pnlCreateCard.Visible = true;
                    pnlCards.Visible = true;
                    BindCards();

                    // Show and populate the edit deck panel
                    pnlEditDeck.Visible = true;
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        conn.Open();
                        using (SqlCommand cmd = new SqlCommand("SELECT DeckTitle, DeckDescription FROM FlashcardDecks WHERE DeckID=@id", conn))
                        {
                            cmd.Parameters.AddWithValue("@id", selectedDeckIdFromQuery);
                            using (var reader = cmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    txtEditDeckTitle.Text = reader["DeckTitle"].ToString();
                                    txtEditDeckDescription.Text = reader["DeckDescription"] == DBNull.Value ? "" : reader["DeckDescription"].ToString();
                                }
                            }
                        }
                    }
                }
            }
        }

        protected void btnSaveDeck_Click(object sender, EventArgs e)
        {
            int deckId = 0;
            if (selectedDeckIdFromQuery > 0)
            {
                deckId = selectedDeckIdFromQuery;
            }
            else if (!string.IsNullOrEmpty(ddlDecks.SelectedValue))
            {
                int.TryParse(ddlDecks.SelectedValue, out deckId);
            }
            if (deckId == 0) return;

            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("UPDATE FlashcardDecks SET DeckTitle=@title, DeckDescription=@desc WHERE DeckID=@id", conn))
                {
                    cmd.Parameters.AddWithValue("@title", txtEditDeckTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@desc", txtEditDeckDescription.Text.Trim());
                    cmd.Parameters.AddWithValue("@id", deckId);
                    cmd.ExecuteNonQuery();
                }
            }
            Response.Redirect($"flashcard.aspx?course={Server.UrlEncode(Request.QueryString["course"])}&deck={deckId}");
        }

        protected void ddlDecks_SelectedIndexChanged(object sender, EventArgs e)
        {
            selectedDeckIdFromQuery = 0;
            if (!string.IsNullOrEmpty(ddlDecks.SelectedValue))
            {
                pnlCreateCard.Visible = true;
                pnlCards.Visible = true;
                pnlEditDeck.Visible = true;
                BindCards();

                // Populate edit deck panel with selected deck info
                int deckId;
                if (int.TryParse(ddlDecks.SelectedValue, out deckId))
                {
                    string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        conn.Open();
                        using (SqlCommand cmd = new SqlCommand("SELECT DeckTitle, DeckDescription FROM FlashcardDecks WHERE DeckID=@id", conn))
                        {
                            cmd.Parameters.AddWithValue("@id", deckId);
                            using (var reader = cmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    txtEditDeckTitle.Text = reader["DeckTitle"].ToString();
                                    txtEditDeckDescription.Text = reader["DeckDescription"] == DBNull.Value ? "" : reader["DeckDescription"].ToString();
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                pnlCreateCard.Visible = false;
                pnlCards.Visible = false;
                pnlEditDeck.Visible = false;
            }
        }

        protected void btnCreateDeck_Click(object sender, EventArgs e)
        {
            string title = txtDeckTitle.Text.Trim();
            string desc = txtDeckDescription.Text.Trim();
            if (string.IsNullOrEmpty(title)) return;

            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            int newDeckId = 0;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("INSERT INTO FlashcardDecks (TC_ID, DeckTitle, DeckDescription) VALUES (@tcid, @title, @desc); SELECT SCOPE_IDENTITY();", conn))
                {
                    cmd.Parameters.AddWithValue("@tcid", currentTCID);
                    cmd.Parameters.AddWithValue("@title", title);
                    cmd.Parameters.AddWithValue("@desc", desc);
                    object idVal = cmd.ExecuteScalar();
                    if (idVal != null && idVal != DBNull.Value)
                        newDeckId = Convert.ToInt32(Convert.ToDecimal(idVal));
                }
            }
            txtDeckTitle.Text = txtDeckDescription.Text = "";
            if (newDeckId > 0)
            {
                Response.Redirect($"flashcard.aspx?course={Server.UrlEncode(Request.QueryString["course"])}&deck={newDeckId}");
            }
            else
            {
                BindDecks();
            }
        }

        protected void btnAddCard_Click(object sender, EventArgs e)
        {
            int deckId = 0;
            if (!string.IsNullOrEmpty(ddlDecks.SelectedValue))
                int.TryParse(ddlDecks.SelectedValue, out deckId);
            if (deckId == 0) return;
            string front = txtFront.Text.Trim();
            string back = txtBack.Text.Trim();
            if (string.IsNullOrEmpty(front) || string.IsNullOrEmpty(back)) return;

            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("INSERT INTO Flashcards (DeckID, FrontText, BackText) VALUES (@deckid, @front, @back)", conn))
                {
                    cmd.Parameters.AddWithValue("@deckid", deckId);
                    cmd.Parameters.AddWithValue("@front", front);
                    cmd.Parameters.AddWithValue("@back", back);
                    cmd.ExecuteNonQuery();
                }
            }
            txtFront.Text = txtBack.Text = "";
            Response.Redirect($"flashcard.aspx?course={Server.UrlEncode(Request.QueryString["course"])}&deck={deckId}");
        }

        protected void BindCards()
        {
            int deckId = 0;
            if (!string.IsNullOrEmpty(ddlDecks.SelectedValue))
                int.TryParse(ddlDecks.SelectedValue, out deckId);
            if (deckId == 0) return;
            DataTable dt = new DataTable();
            string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT FlashcardID, FrontText, BackText FROM Flashcards WHERE DeckID=@deckid", conn))
                {
                    cmd.Parameters.AddWithValue("@deckid", deckId);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }
            rptCards.DataSource = dt;
            rptCards.DataBind();
        }

        protected void rptCards_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeleteCard")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                string connStr = ConfigurationManager.ConnectionStrings["WAPPConnectionString"].ConnectionString;
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("DELETE FROM Flashcards WHERE FlashcardID=@id", conn))
                    {
                        cmd.Parameters.AddWithValue("@id", id);
                        cmd.ExecuteNonQuery();
                    }
                }

                // After delete, reload cards for the current deck
                int deckId = 0;
                if (!string.IsNullOrEmpty(ddlDecks.SelectedValue))
                    int.TryParse(ddlDecks.SelectedValue, out deckId);
                Response.Redirect($"flashcard.aspx?course={Server.UrlEncode(Request.QueryString["course"])}&deck={deckId}");
            }
        }
    }
}