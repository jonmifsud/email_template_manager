<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml"
	omit-xml-declaration="yes"
	encoding="UTF-8"
	indent="yes" />

<xsl:template name='recipient'>
	<xsl:param name='type' select="'recipients'"/>
	<xsl:param name='label' select="'Recipients'"/>
	<div>
		<xsl:if test="/data/errors/*[local-name() = $type]">
			<xsl:attribute name="class">
				<xsl:text>invalid</xsl:text>
			</xsl:attribute>
		</xsl:if>
		<label>
			<xsl:value-of select='$label'/>
			<i>optional</i>
			<input type="text" name="fields[{$type}]">
				<xsl:attribute name="value">
					<xsl:if test="/data/fields">
						<xsl:value-of select="/data/fields/*[local-name() = $type]"/>
					</xsl:if>
					<xsl:if test="not(/data/fields)">
						<xsl:value-of select="/data/templates/entry/*[local-name() = $type]"/>
					</xsl:if>
				</xsl:attribute>
			</input>
		</label>
		<xsl:if test="/data/errors/*[local-name() = $type]">
			<p><xsl:value-of select="/data/errors/*[local-name() = $type]"/></p>
		</xsl:if>
		<xsl:if test="not(/data/errors/*[local-name() = $type])">
			<p class="help">Select multiple recipients by seperating them with commas. This is also possible dynamically: <code>{/data/authors/author/name} &lt;{/data/authors/author/email}&gt;</code> will return: <code>name &lt;email@domain.com&gt;, name2 &lt;email2@domain.com&gt;</code></p>
		</xsl:if>
	</div>
</xsl:template>

<xsl:template match="/">
	<form method="post" action="{$current-url}">
		<fieldset class="settings">
			<legend>Template Settings</legend>
			<div>
				<xsl:if test="/data/errors/name">
					<xsl:attribute name="class">
						<xsl:text>invalid</xsl:text>
					</xsl:attribute>
				</xsl:if>
				<label>
					Name
					<input type="text" name="fields[name]">
						<xsl:attribute name="value">
							<xsl:if test="/data/fields">
								<xsl:value-of select="/data/fields/name"/>
							</xsl:if>
							<xsl:if test="not(/data/fields)">
								<xsl:value-of select="/data/templates/entry/name"/>
							</xsl:if>
						</xsl:attribute>
					</input>
				</label>
				<xsl:if test="/data/errors/name">
					<p><xsl:value-of select="/data/errors/name"/></p>
				</xsl:if>
			</div>
			<label>
				Datasources
				<i>optional</i>
				<select multiple="multiple" name="fields[datasources][]">
					<xsl:for-each select="/data/datasources/entry">
						<option value="{handle}">
							<xsl:if test="/data/fields">
								<xsl:if test="/data/fields/datasources/item = handle">
									<xsl:attribute name="selected" select="'selected'"/>
								</xsl:if>
							</xsl:if>
							<xsl:if test="not(/data/fields)">
								<xsl:if test="/data/templates/entry/datasources/item = handle">
									<xsl:attribute name="selected" select="'selected'"/>
								</xsl:if>
							</xsl:if>
							<xsl:value-of select="name"/>
						</option>
					</xsl:for-each>
					<xsl:if test="not(/data/datasources/entry)">
						<option value="0" disabled="1">No datasources installed</option>
					</xsl:if>
				</select>
			</label>
			<p class="help">Layouts will be able to use these datasources to build their content.</p>
			<label>
				Layouts
				<select name="fields[layouts]">
					<option value="both">
						<xsl:if test="(/data/templates/entry/layouts/html) and (/data/templates/entry/layouts/plain) or (not(/data/templates/entry/layouts/html) and not(/data/templates/entry/layouts/plain))">
							<xsl:attribute name="selected">1</xsl:attribute>
						</xsl:if>
						HTML and Plain
					</option>
					<option value="html">
						<xsl:if test="not(/data/templates/entry/layouts/plain) and (/data/templates/entry/layouts/html)">
							<xsl:attribute name="selected">1</xsl:attribute>
						</xsl:if>
						HTML only
					</option>
					<option value="plain">
						<xsl:if test="not(/data/templates/entry/layouts/html) and (/data/templates/entry/layouts/plain)">
							<xsl:attribute name="selected">
								1
							</xsl:attribute>
						</xsl:if>
						Plain only
					</option>
				</select>
			</label>
			<p class="help">Only the layouts selected will be emailed.</p>
		</fieldset>
		<fieldset class="settings">
			<legend>Email Settings</legend>
			<p class="help">These settings are global settings for this template. They can be overwritten by extensions or custom events. <br /><br />Use the {$param} and {/xpath/query} notation to include dynamic parts. It is not possible to combine the two syntaxes: {/xpath/$param} is not possible.</p>
			<div>
				<xsl:if test="/data/errors/subject">
					<xsl:attribute name="class">
						<xsl:text>invalid</xsl:text>
					</xsl:attribute>
				</xsl:if>
				<label>
					Subject
					<input type="text" name="fields[subject]">

						<xsl:attribute name="value">
							<xsl:if test="/data/fields">
								<xsl:value-of select="/data/fields/subject"/>
							</xsl:if>
							<xsl:if test="not(/data/fields)">
								<xsl:value-of select="/data/templates/entry/subject"/>
							</xsl:if>
						</xsl:attribute>
					</input>
				</label>
				<xsl:if test="/data/errors/subject">
					<p><xsl:value-of select="/data/errors/subject"/></p>
				</xsl:if>
				<xsl:if test="not(/data/errors/subject)">
					<p class="help">Use the {$param} and {/xpath/query} notation to include dynamic parts. It is not possible to combine the two syntaxes. If the XPath returns more than one result, only the first is used</p>
				</xsl:if>
			</div>
			<xsl:call-template name='recipient'>
				<xsl:with-param name='type' select='"recipients"'/>
				<xsl:with-param name='label' select='"Recipients"'/>
			</xsl:call-template>
			<xsl:call-template name='recipient'>
				<xsl:with-param name='type' select='"ccrecipients"'/>
				<xsl:with-param name='label' select='"Cc Recipients"'/>
			</xsl:call-template>
			<xsl:call-template name='recipient'>
				<xsl:with-param name='type' select='"bccrecipients"'/>
				<xsl:with-param name='label' select='"Bcc Recipients"'/>
			</xsl:call-template>

			<label>
				Send Email
				<i>optional</i>
				<input type="text" name="fields[test]">
					<xsl:attribute name="value">
						<xsl:if test="/data/fields">
							<xsl:value-of select="/data/fields/test"/>
						</xsl:if>
						<xsl:if test="not(/data/fields) and /data/templates/entry/test">
							<xsl:value-of select="/data/templates/entry/test"/>
						</xsl:if>
					</xsl:attribute>
				</input>
			</label>
			<p class="help">This is a test to check if email is to be sent, if it evaluates to 'no' or otherwise not found in xpath will not send the email. Leave blank to send always</p>

			<div class="group">
				<div>
					<xsl:if test="/data/errors/sender-name">
						<xsl:attribute name="class">
							<xsl:text>invalid</xsl:text>
						</xsl:attribute>
					</xsl:if>
					<label>
						Reply-To Name
						<i>optional</i>
						<input type="text" name="fields[reply-to-name]">
							<xsl:attribute name="value">
								<xsl:if test="/data/fields">
									<xsl:value-of select="/data/fields/reply-to-name"/>
								</xsl:if>
								<xsl:if test="not(/data/fields) and /data/templates/entry/reply-to-name">
									<xsl:value-of select="/data/templates/entry/reply-to-name"/>
								</xsl:if>
							</xsl:attribute>
						</input>
					</label>
					<xsl:if test="/data/errors/reply-to-name">
						<p><xsl:value-of select="/data/errors/reply-to-name"/></p>
					</xsl:if>
				</div>
				<div>
					<xsl:if test="/data/errors/sender-email-address">
						<xsl:attribute name="class">
							<xsl:text>invalid</xsl:text>
						</xsl:attribute>
					</xsl:if>
					<label>
						Reply-To Email Address
						<i>optional</i>
						<input type="text" name="fields[reply-to-email-address]">
							<xsl:attribute name="value">
								<xsl:if test="/data/fields">
									<xsl:value-of select="/data/fields/reply-to-email-address"/>
								</xsl:if>
								<xsl:if test="not(/data/fields) and /data/templates/entry/reply-to-email-address">
									<xsl:value-of select="/data/templates/entry/reply-to-email-address"/>
								</xsl:if>
							</xsl:attribute>
						</input>
					</label>
					<xsl:if test="/data/errors/reply-to-email-address">
						<p><xsl:value-of select="/data/errors/reply-to-email-address"/></p>
					</xsl:if>
				</div>
			</div>
		</fieldset>
		<div class="actions">
			<input type="submit" accesskey="s" name="action[save]">
				<xsl:attribute name="value">
					<xsl:choose>
						<xsl:when test="/data/templates/entry/name">Save Changes</xsl:when>
						<xsl:otherwise>Create Template</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</input>
			<xsl:if test="not(/data/context/item[@index=1] = 'new')" >
				<button accesskey="d" title="Delete this page" class="button confirm delete" name="action[delete]">Delete</button>
			</xsl:if>
		</div>
		</form>
</xsl:template>
</xsl:stylesheet>