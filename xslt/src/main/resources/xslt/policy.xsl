<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- Output HTML -->
    <xsl:output method="html" indent="yes"/>

    <!-- R3: Date formatting (yyyy-MM-dd → dd/MM/yyyy) -->
    <xsl:template name="formatDate">
        <xsl:param name="date"/>
        <xsl:choose>
            <xsl:when test="string-length($date) = 10">
                <xsl:value-of
                    select="concat(substring($date,9,2), '/',
                                   substring($date,6,2), '/',
                                   substring($date,1,4))"/>
            </xsl:when>
            <xsl:otherwise>N/A</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Root -->
    <xsl:template match="/">
        <html>
        <head>
            <title>Policy Summary</title>
            <style>
                table { border-collapse: collapse; width: 60%; margin-bottom: 20px; }
                th, td { border: 1px solid #333; padding: 8px; }
                th { background-color: #eee; }
            </style>
        </head>

        <body>
            <h2>Policy Details</h2>

            <table>
                <tr><th>Field</th><th>Value</th></tr>

                <!-- R4: Show N/A if field missing -->
                <tr>
                    <td>Policy Number</td>
                    <td>
                        <xsl:choose>
                            <xsl:when test="string(Policy/PolicyNumber) != ''">
                                <xsl:value-of select="Policy/PolicyNumber"/>
                            </xsl:when>
                            <xsl:otherwise>N/A</xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>

                <!-- R4: Show N/A if empty -->
                <tr>
                    <td>Insured Name</td>
                    <td>
                        <xsl:choose>
                            <xsl:when test="string(Policy/InsuredName) != ''">
                                <xsl:value-of select="Policy/InsuredName"/>
                            </xsl:when>
                            <xsl:otherwise>N/A</xsl:otherwise>
                        </xsl:choose>
                    </td>
                </tr>

                <!-- R3: Apply date formatting -->
                <tr>
                    <td>Issue Date</td>
                    <td>
                        <xsl:call-template name="formatDate">
                            <xsl:param name="date" select="Policy/IssueDate"/>
                        </xsl:call-template>
                    </td>
                </tr>

                <!-- R1: If Premium > 5000 → red text -->
                <tr>
                    <td>Premium</td>
                    <td>
                        <xsl:variable name="premium" select="Policy/Premium"/>
                        <span>
                            <xsl:attribute name="style">
                                <xsl:if test="$premium &gt; 5000">
                                    color:red;font-weight:bold;
                                </xsl:if>
                            </xsl:attribute>
                            <xsl:value-of select="$premium"/>
                        </span>
                    </td>
                </tr>

            </table>

            <!-- R2: Show coverages section only if exists -->
            <xsl:choose>
                <xsl:when test="Policy/Coverages/Coverage">

                    <!-- R6: If more than 5 coverages → show note -->
                    <xsl:if test="count(Policy/Coverages/Coverage) &gt; 5">
                        <p><strong>Note:</strong> Many coverages selected.</p>
                    </xsl:if>

                    <h3>Coverage Details</h3>
                    <table>
                        <tr><th>Coverage Type</th><th>Sum Insured</th></tr>

                        <!-- R5: Sort coverages by SumInsured descending -->
                        <xsl:for-each select="Policy/Coverages/Coverage">
                            <xsl:sort select="SumInsured" data-type="number" order="descending"/>
                            <tr>
                                <!-- R4: Show N/A if type missing -->
                                <td>
                                    <xsl:choose>
                                        <xsl:when test="string(Type) != ''">
                                            <xsl:value-of select="Type"/>
                                        </xsl:when>
                                        <xsl:otherwise>N/A</xsl:otherwise>
                                    </xsl:choose>
                                </td>

                                <!-- R4: Show N/A if SumInsured missing -->
                                <td>
                                    <xsl:choose>
                                        <xsl:when test="string(SumInsured) != ''">
                                            <xsl:value-of select="SumInsured"/>
                                        </xsl:when>
                                        <xsl:otherwise>N/A</xsl:otherwise>
                                    </xsl:choose>
                                </td>
                            </tr>
                        </xsl:for-each>

                    </table>
                </xsl:when>

                <!-- R7: Display message if no coverage -->
                <xsl:otherwise>
                    <p><strong>No Coverage Information Available</strong></p>
                </xsl:otherwise>

            </xsl:choose>

        </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
