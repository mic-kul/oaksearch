
CREATE OR REPLACE function ref_cursor_to_json (p_ref_cursor in sys_refcursor,
p_max_rows in number := null, p_skip_rows in number := null) return xmltype AS
	l_ctx         dbms_xmlgen.ctxhandle;
	l_num_rows    pls_integer;
	l_xml         xmltype;
	l_json        xmltype;
	l_returnvalue clob;
begin
	l_ctx := dbms_xmlgen.newcontext (p_ref_cursor);
	dbms_xmlgen.setnullhandling (l_ctx, dbms_xmlgen.empty_tag);

	-- for pagination
	if p_max_rows is not null then
		dbms_xmlgen.setmaxrows (l_ctx, p_max_rows);
	end if;

	if p_skip_rows is not null then
		dbms_xmlgen.setskiprows (l_ctx, p_skip_rows);
	end if;

	-- get the XML content
	l_xml := dbms_xmlgen.getxmltype (l_ctx, dbms_xmlgen.none);
	l_num_rows := dbms_xmlgen.getnumrowsprocessed (l_ctx);
	dbms_xmlgen.closecontext (l_ctx);

	close p_ref_cursor;

	return l_xml;
end ref_cursor_to_json;
/

/* Created by Julia Osiak, PJWSTK 2014, Bachelor of Science Thesis */