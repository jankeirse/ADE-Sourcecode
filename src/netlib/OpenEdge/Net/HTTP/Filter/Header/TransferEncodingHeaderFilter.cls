/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : TransferEncodingHeaderFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Feb 14 11:47:30 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Filter.FilterActionEnum.
using OpenEdge.Net.HTTP.Filter.Header.IHeaderFilter.
using OpenEdge.Net.HTTP.HttpMessage.
using OpenEdge.Net.HTTP.TransferEncodingEnum.

class OpenEdge.Net.HTTP.Filter.Header.TransferEncodingHeaderFilter implements IHeaderFilter:
    /** The name of the header that this filter applies to. Can be a complete
        header or part thereof. This property mainly allows external inspection
        but also allows clean code, since it allows us to restruict hard-coding.  */
    define public property HeaderName as character initial 'Transfer-Encoding' no-undo get. 
    
	constructor public TransferEncodingHeaderFilter():
	end constructor.
	
	/** Indicates whether this filter applies to the current header.     

        @param  character The header name to filter
        @return logical True if the current filter can be used. */
    method public logical CanFilter(input pcName as character ):
        return (pcName eq HeaderName).
    end method.
	
    /** Performs implementation-specific filtering for a header.
        
        @param character The header name on which to filter
        @param character The header value 
        @param HttpMessage Filter data. The data to which the filter is applied.
                           This is only relevant for HttpMessages (request or
                           response).
        @return FilterActionEnum Status of the fitler action. The caller decides
                                 what to do with this information. Filters will
                                 typically return Stop or OK. */
    method public FilterActionEnum ExecuteFilter(input pcName as character,
                                                 input pcValue as character,
                                                 input poFilterData as HttpMessage):
	    define variable oTransferEncoding as TransferEncodingEnum no-undo.
	    
	    oTransferEncoding = TransferEncodingEnum:FromString(pcValue).
	    
        poFilterData:TransferEncoding = oTransferEncoding.
        
        return FilterActionEnum:Stop.
    end method.
	
end class.